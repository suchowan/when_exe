# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2011-2012 Takashi SUGA

  You may use and/or modify this file according to the license described in the LICENSE.txt file included in this archive.
=end

class When::TM::CalendarEra

  #
  # 皇紀
  #
  NihonKoki = [self, [
    "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
    "locale:[=ja:, en=en:, alias]",
    "area:[日本]",
    ["[皇紀]1",		"[::_m:EpochEvents::Accession]",	"-659-01-01^Chinese::儀鳳暦"],
    ["[皇紀]1113",	"[::_m:EpochEvents::CalendarReform]",	"0453-12-14^Chinese::元嘉暦"],
    ["[皇紀]1253",	"",					"0593-01-01^Japanese"],
    ["[皇紀]2533",	"[::_m:EpochEvents::CalendarReform]",	"1873-01-01^Gregorian"]
  ]]

  #
  # 日本書紀暦日
  #
  NihonShoki = [self, [
    "namespace:[ja=http://ja.wikipedia.org/wiki/, en=http://en.wikipedia.org/wiki/]",
    "locale:[=ja:, en=en:, alias]",
    "period:[(日本書紀)=ja:%E6%97%A5%E6%9C%AC%E6%9B%B8%E7%B4%80, (Nihon_Shoki)=en:Nihon_Shoki]",
    ["[神武]1",	"[::_m:EpochEvents::Accession]",	"name=[神武];-659-01-01^Chinese::儀鳳暦"],
    ["[綏靖]1",	"[::_m:EpochEvents::Accession]",	"name=[綏靖];-580-01-08"],
    ["[安寧]0",	"[::_m:EpochEvents::Accession]",	"name=[安寧];-548-07-03"],
    ["[懿徳]1",	"[::_m:EpochEvents::Accession]",	"name=[懿徳];-509-02-04"],
    ["[孝昭]1",	"[::_m:EpochEvents::Accession]",	"name=[孝昭];-474-01-09"],
    ["[孝安]1",	"[::_m:EpochEvents::Accession]",	"name=[孝安];-391-01-07"],
    ["[孝霊]1",	"[::_m:EpochEvents::Accession]",	"name=[孝霊];-289-01-12"],
    ["[孝元]1",	"[::_m:EpochEvents::Accession]",	"name=[孝元];-213-01-14"],
    ["[開化]0",	"[::_m:EpochEvents::Accession]",	"name=[開化];-157-11-12"],
    ["[崇神]1",	"[::_m:EpochEvents::Accession]",	"name=[崇神];-096-01-13"],
    ["[垂仁]1",	"[::_m:EpochEvents::Accession]",	"name=[垂仁];-028-01-02"],
    ["[景行]1",	"[::_m:EpochEvents::Accession]",	"name=[景行];0071-07-11"],
    ["[成務]1",	"[::_m:EpochEvents::Accession]",	"name=[成務];0131-01-05"],
    ["[仲哀]1",	"[::_m:EpochEvents::Accession]",	"name=[仲哀];0192-01-11"],
    ["[神功皇后]0",	"[::_m:EpochEvents::Accession]","name=[神功皇后];0200-02-07"],
    ["[応神]1",	"[::_m:EpochEvents::Accession]",	"name=[応神];0270-01-01"],
    ["[仁徳]1",	"[::_m:EpochEvents::Accession]",	"name=[仁徳];0313-01-03"],
    ["[履中]1",	"[::_m:EpochEvents::Accession]",	"name=[履中];0400-02-01"],
    ["[反正]1",	"[::_m:EpochEvents::Accession]",	"name=[反正];0406-01-02"],
    ["[允恭]1",	"[::_m:EpochEvents::Accession]",	"name=[允恭];0412-12"],
    ["[安康]0",	"[::_m:EpochEvents::Accession]",	"name=[安康];0453-12-14^Chinese::元嘉暦"],
    ["[雄略]0",	"[::_m:EpochEvents::Accession]",	"name=[雄略];0456-11-13"],
    ["[清寧]1",	"[::_m:EpochEvents::Accession]",	"name=[清寧];0480-01-15"],
    ["[顕宗]1",	"[::_m:EpochEvents::Accession]",	"name=[顕宗];0485-01-01"],
    ["[仁賢]1",	"[::_m:EpochEvents::Accession]",	"name=[仁賢];0488-01-05"],
    ["[武烈]0",	"[::_m:EpochEvents::Accession]",	"name=[武烈];0498-12"],
    ["[継体]1",	"[::_m:EpochEvents::Accession]",	"name=[継体];0507-02-04"],
    ["[安閑]1",	"[::_m:EpochEvents::Accession]",	"name=[安閑];0534"],
    ["[宣化]0",	"[::_m:EpochEvents::Accession]",	"name=[宣化];0535-12"],
    ["[欽明]0",	"[::_m:EpochEvents::Accession]",	"name=[欽明];0539-12-05"],
    ["[敏達]1",	"[::_m:EpochEvents::Accession]",	"name=[敏達];0572-04-03"],
    ["[用明]0",	"[::_m:EpochEvents::Accession]",	"name=[用明];0585-09-05"],
    ["[崇峻]0",	"[::_m:EpochEvents::Accession]",	"name=[崇峻];0587-08-02"],
    ["[推古]0",	"[::_m:EpochEvents::Accession]",	"name=[推古];0592-12-08"],
    ["[舒明]1",	"[::_m:EpochEvents::Accession]",	"name=[舒明];0629-01-04"],
    ["[皇極]1",	"[::_m:EpochEvents::Accession]",	"name=[皇極];0642-01-15"],
    ["[大化]1",	"[::_m:EpochEvents::Accession]",	"name=[孝徳];0645-06-19"],
    ["[白雉]1",	"[::_m:EpochEvents::FelicitousEvent]",	"	     0650-02-15"],
    ["[斉明]1",	"[::_m:EpochEvents::Accession]",	"name=[斉明];0655-01-03"],
    ["[天智]1",	"[::_m:EpochEvents::Accession]",	"name=[天智];0662-01-01"],
    ["[天武]1",	"[::_m:EpochEvents::Accession]",	"name=[天武];0672-01-01"],
    ["[朱鳥]1",	"",					"	     0686-07-20", "0687-01-01"]
  ]]
end
