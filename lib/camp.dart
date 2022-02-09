import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'gmap.dart';

import 'validator.dart';


class Camp {
  final int id;
  final DateTime date;
  final int tents;
  final int bags;


  Camp(this.id, this.date, this.tents, this.bags);


}