namespace VisitDreznica.Model.Constants;

public static class ValidationPatterns
{
    public const string Password = @"^(?=.*[A-Za-z])(?=.*\d).{8,}$";
    public const string PasswordMessage = "Lozinka mora imati najmanje 8 znakova, uključujući barem jedno slovo i jedan broj.";

    public const string Phone = @"^\+?[0-9 ]{6,20}$";
    public const string PhoneMessage = "Unesite ispravan broj telefona, npr. 061 234 567 ili +387 61 234 567.";

    public const string Username = @"^[a-zA-Z0-9._]{3,50}$";
    public const string UsernameMessage = "Korisničko ime mora imati 3–50 znakova: slova, brojevi, tačka ili donja crta.";
}