<?php

namespace App\Http\Controllers\SobatBunda;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class ReservationController extends Controller
{
    public function index() {
        $reservation = DB::connection('sqlsrv')
            ->table('SIMtrReservasi')
            ->where('NoReservasi', '250926RESOL-026406')
            ->first();

        return response()->json($reservation);
    }
}
