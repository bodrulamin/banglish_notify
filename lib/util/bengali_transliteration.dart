import 'dart:convert';

import 'package:banglish_notify/util/lang_utils.dart';

class BengaliLanguageUtils extends LanguageUtils {
  static final Map<String, String> composites = {
    "ক্ষ": "kkh",
    "ঞ্চ": "NC",
    "ঞ্ছ": "NCh",
    "ঞ্জ": "Ng",
    "জ্ঞ": "gg",
    "ঞ্ঝ": "Ngh",
    "্র": "r",
    "্ল": "l",
    "ষ্ম": "SSh",
    "র্": "r",
    "্য": "y",
    "্ব": "w",
  };

  static final Map<String, String> vowels = {
    "আ": "aa",
    "অ": "a",
    "ই": "i",
    "ঈ": "ii",
    "উ": "u",
    "ঊ": "uu",
    "ঋ": "ri",
    "এ": "e",
    "ঐ": "oi",
    "ও": "o",
    "ঔ": "ou",
  };

  static final Map<String, String> vowelsAndHasants = {
    "আ": "aa",
    "অ": "a",
    "ই": "i",
    "ঈ": "ii",
    "উ": "u",
    "ঊ": "uu",
    "ঋ": "ri",
    "এ": "e",
    "ঐ": "oi",
    "ও": "o",
    "ঔ": "ou",
    "া": "aa",
    "ি": "i",
    "ী": "ii",
    "ু": "u",
    "ূ": "uu",
    "ৃ": "r",
    "ে": "e",
    "ো": "o",
    "ৈ": "oi",
    "ৗ": "ou",
    "ৌ": "ou",
    "ং": "ng",
    "ঃ": "h",
    "।": ".",
  };

  static final Map<String, String> letters = {
    "আ": "aa",
    "অ": "a",
    "ই": "i",
    "ঈ": "ii",
    "উ": "u",
    "ঊ": "uu",
    "ঋ": "ri",
    "এ": "e",
    "ঐ": "oi",
    "ও": "o",
    "ঔ": "ou",
    "ক": "k",
    "খ": "kh",
    "গ": "g",
    "ঘ": "gh",
    "ঙ": "ng",
    "চ": "ch",
    "ছ": "chh",
    "জ": "j",
    "ঝ": "jh",
    "ঞ": "Ng",
    "ট": "T",
    "ঠ": "Th",
    "ড": "D",
    "ঢ": "Dh",
    "ণ": "N",
    "ত": "t",
    "থ": "th",
    "দ": "d",
    "ধ": "dh",
    "ন": "n",
    "প": "p",
    "ফ": "ph",
    "ব": "b",
    "ভ": "bh",
    "ম": "m",
    "য": "J",
    "র": "r",
    "ল": "l",
    "শ": "sh",
    "ষ": "Sh",
    "স": "s",
    "হ": "h",
    "ড়": "rh",
    "ঢ়": "rH",
    "য়": "y",
    "ৎ": "t",
    "০": "0",
    "১": "1",
    "২": "2",
    "৩": "3",
    "৪": "4",
    "৫": "5",
    "৬": "6",
    "৭": "7",
    "৮": "8",
    "৯": "9",
    "া": "aa",
    "ি": "i",
    "ী": "ii",
    "ু": "u",
    "ূ": "uu",
    "ৃ": "r",
    "ে": "e",
    "ো": "o",
    "ৈ": "oi",
    "ৗ": "ou",
    "ৌ": "ou",
    "ং": "ng",
    "ঃ": "h",
    "ঁ": "nN",
    "।": ".",
  };

  static final RegExp bengaliRegex = RegExp(
      r'(র্){0,1}(([অ-হড়-য়])(্([অ-মশ-হড়-য়]))*)((‍){0,1}(্([য-ল]))){0,1}([া-ৌ]){0,1}|([্ঁঃংৎ০-৯।])|(\s)');

  static String? getVal(String? key) {
    if (key != null) {
      String? comp = composites[key];
      if (comp != null) {
        return comp;
      }
      String? sl = letters[key];
      if (sl != null) {
        return letters[key];
      }
    }
    return null;
  }

  static String transliterate(String txt) {
    if (txt.isEmpty) {
      return txt;
    }

    StringBuffer sb = StringBuffer();
    String lastChar = "";
    bool lastHadComposition = false;
    bool lastHadKaar = false;
    bool nextNeedsO = false;
    int lastHadO = 0;

    Iterable<RegExpMatch> matches = bengaliRegex.allMatches(txt);
    for (RegExpMatch m in matches) {
      bool thisNeedsO = false;
      bool changePronounciation = false;
      bool thisHadKaar = false;
      String appendableString = "";
      String? reff = m.group(1);
      if (reff != null) {
        appendableString += "rr";
      }
      String? mainPart = getVal(m.group(2));
      if (mainPart != null) {
        appendableString += mainPart;
      } else {
        String? firstPart = getVal(m.group(3));
        if (firstPart != null) {
          appendableString += firstPart;
        }
        int g = 4;
        while (g < 6) {
          String? part = getVal(m.group(g));
          if (part != null) {
            appendableString += part;
            break;
          }
          g++;
        }
      }
      if (m.group(2) != null && m.group(2) == "ক্ষ") {
        changePronounciation = true;
        thisNeedsO = true;
      }
      int g = 6;
      while (g < 10) {
        String? key = getVal(m.group(g));
        if (key != null) {
          appendableString += key;
          break;
        }
        g++;
      }
      String? phala = m.group(8);
      if (phala != null && phala == "্য") {
        changePronounciation = true;
        thisNeedsO = true;
      }
      String? jukto = m.group(4);
      if (jukto != null) {
        thisNeedsO = true;
      }
      String? kaar = m.group(10);
      if (kaar != null) {
        String? kaarStr = letters[kaar];
        if (kaarStr != null) {
          appendableString += kaarStr;
          if (kaarStr == "i" ||
              kaarStr == "ii" ||
              kaarStr == "u" ||
              kaarStr == "uu") {
            changePronounciation = true;
          }
        }
      }
      String? singleton = m.group(11);
      if (singleton != null) {
        String? singleStr = letters[singleton];
        if (singleStr != null) {
          appendableString += singleStr;
        }
      }
      if (changePronounciation && lastChar == "a") {
        sb.writeCharCode(111); // ASCII for 'o'
      }
      String? others = m.group(0);
      if (others != null) {
        if (appendableString.length <= 0) {
          appendableString += others;
        }
      }
      String? whitespace = m.group(12);
      if (nextNeedsO &&
          kaar == null &&
          whitespace == null &&
          !vowels.containsKey(m.group(0))) {
        appendableString += "o";
        lastHadO++;
        thisNeedsO = false;
      }

      if (((kaar != null && lastHadO > 1) || whitespace != null) &&
          !lastHadKaar &&
          sb.length > 0 &&
          sb.toString().endsWith("o") &&
          !lastHadComposition) {
        sb.writeCharCode(111); // ASCII for 'o'
        lastHadO = 0;
      }
      nextNeedsO = false;
      if (thisNeedsO &&
          kaar == null &&
          whitespace == null &&
          !vowels.containsKey(m.group(0))) {
        appendableString += "o";
        lastHadO++;
      }
      if (appendableString.length > 0 &&
          !vowelsAndHasants.containsKey(m.group(0)) &&
          kaar == null) {
        nextNeedsO = true;
      }
      if (reff != null || m.group(4) != null || m.group(6) != null) {
        lastHadComposition = true;
      } else {
        lastHadComposition = false;
      }
      if (kaar != null) {
        lastHadKaar = true;
      } else {
        lastHadKaar = false;
      }
      sb.write(appendableString);
      lastChar = appendableString;
    }
    if (!lastHadKaar &&
        sb.length > 0 &&
        sb.toString().endsWith("o") &&
        !lastHadComposition) {
      sb.writeCharCode(111); // ASCII for 'o'
    }
    return sb.toString();
  }
}

