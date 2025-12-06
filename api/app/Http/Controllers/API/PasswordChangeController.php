<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Http\Controllers\Controller;
use App\Mail\ChangePassword;
use App\Models\UniqueToken;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class PasswordChangeController extends Controller
{
    public function send_token(Request $request)
    {
        $validated = $request->validate(["email" => "email|required"]);
        $user = User::where("email", $validated["email"])->first();

        if (!$user) {
            return ResponseWrapper::make(
                "Email tidak terdaftar",
                404,
                false,
                null,
                null,
            );
        }
        try {
            $token = $this->get_and_save_token();
            Mail::to($user["email"])->send(new ChangePassword($token));
            return ResponseWrapper::make(
                "Sukses mengirim token",
                200,
                true,
                $user["id"],
                null,
            );
        } catch (\Error $err) {
            \Log::error("Failed to send token to email", [
                "error" => $err->getMessage(),
            ]);
            return ResponseWrapper::make(
                "Gagal mengirim email",
                500,
                false,
                null,
                null,
            );
        }
    }

    public function check_token(Request $request)
    {
        try {
            $validated = $request->validate(["token" => "required|string"]);

            $isTokenExist = UniqueToken::where(
                "token",
                $validated["token"],
            )->first();

            if (!$isTokenExist) {
                return ResponseWrapper::make(
                    "Token tidak valid",
                    404,
                    false,
                    null,
                    null,
                );
            }
            return ResponseWrapper::make("Sukses", 200, true, null, null);
        } catch (\Error $err) {
            return ResponseWrapper::make(
                "Failed to change password",
                500,
                false,
                null,
                null,
            );
        }
    }

    public function change_password(Request $request)
    {
        try {
            $validated = $request->validate([
                "user_id" => "required|int",
                "new_password" => "required|string|max:225",
            ]);

            User::where("id", $validated["user_id"])->update([
                "password" => Hash::make($validated["new_password"]),
            ]);

            return ResponseWrapper::make(
                "Sukses mengganti password",
                200,
                true,
                null,
                null,
            );
        } catch (\Error $err) {
            return ResponseWrapper::make(
                "Failed to change password",
                500,
                false,
                null,
                null,
            );
        }
    }

    private function get_and_save_token()
    {
        try {
            $returnedToken = "";
            do {
                $returnedToken = $this->generate_token();
                $existingToken = UniqueToken::where(
                    "token",
                    $returnedToken,
                )->first();
            } while ($existingToken);

            UniqueToken::create(["token" => $returnedToken]);
            return $returnedToken;
        } catch (\Exception $err) {
            \Log::error("Error in generating token: " . $err->getMessage());
            throw $err;
        }
    }

    private function generate_token(): string
    {
        return (string) mt_rand(1000, 9999);
    }
}
