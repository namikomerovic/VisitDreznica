namespace VisitDreznica.Services.Recommendations;

public static class InteractionWeights
{
    public const float Favorite = 4.5f;
    public const float CompletedReservation = 4.0f;
    public const float ConfirmedReservation = 3.5f;
    public const float SingleView = 2.5f;
    public const float RepeatedView = 3.0f;
    public const float FrequentView = 3.5f;

    public const float LikedThreshold = 4.0f;
}