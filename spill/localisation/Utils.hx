package spill.localisation;

class Utils
{
  // converts the codes used by Spil to internal language codes
  public static function fromSpilLangCode(v : String) : String
  {
    switch(v)
    {
      case "en_us":
        return "EN_US";

      case "en_uk":
        return "EN_UK";

      case "es_mx":
        return "MX";

      case "es_ar":
        return "AR";

      case "ar":
        return "SA";
    }

    return v.toUpperCase();
  }

  public static function toSpilLangCode(v : String) : String
  {
    switch(v)
    {
      case "EN_US":
        return "en_us";

      case "EN_UK":
        return "en_uk";

      case "MX":
        return "es_mx";

      case "AR":
        return "es_ar";

      case "SA":
        return "ar";
    }

    return v.toLowerCase();
  }
}