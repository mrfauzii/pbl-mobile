<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class FullEmployeeSeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            ['admin',               'admin@email.com',      true,  3, 2], // Supervisor HR
            ['user',                'user@email.com',       false,  2, 1], // Senior Staff IT
            ['Aditya Yuhanda Putra','aditya@email.com',     false,  7, 1], // Direktur IT
            ['Paudra Akbar Buana',  'paud@email.com',       false,  5, 2], // Manager HR
            ['Husein Fadhullah',    'husein@email.com',     false,  4, 1], // Asst Manager IT
            ['Hamdan Ubaidillah',   'hamdanubaidillah0306@gmail.com',    true,  3, 1], // Supervisor IT
            ['Ahmad Fauzi',         'ahmad@email.com',      false,  2, 1], // Senior Staff IT
            ['Dewi Sartika',        'dewi@email.com',       false,  1, 3], // Staff Finance
            ['Joko Widodo',         'joko@email.com',       false,  3, 4], // Supervisor Marketing
            ['Larasati Putri',      'laras@email.com',      true,  1, 2], // Staff HR (admin)
            ['Eko Prasetyo',        'eko@email.com',        false,  2, 5], // Senior Staff Operational
            ['Nina Kusuma',         'nina@email.com',       false,  1, 6], // Staff GA
            ['Fajar Siddiq',        'fajar@email.com',      false,  4, 1], // Asst Manager IT
            ['Putri Ayu',           'putri@email.com',      false,  1, 4], // Staff Marketing
        ];

        foreach ($data as $i => $item) {
            [$nama, $email, $isAdmin, $posId, $deptId] = $item;
            $namaArr = explode(' ', $nama);

            $userId = DB::table('users')->insertGetId([
                'email' => $email,
                'password' => Hash::make('password123'),
                'is_admin' => $isAdmin,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            DB::table('employees')->insert([
                'user_id' => $userId,
                'first_name' => $namaArr[0],
                'last_name' => $namaArr[1] ?? '',
                'gender' => ($i % 2 == 0) ? 'L' : 'P',
                'address' => 'Malang, Jawa Timur',
                'position_id' => $posId,
                'department_id' => $deptId,
                'employment_status' => 'aktif',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}