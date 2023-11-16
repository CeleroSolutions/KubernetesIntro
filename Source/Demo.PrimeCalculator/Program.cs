var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/findPrime", () =>
{
    return FindNthPrime(50000);
})
.WithName("Calculate Prime Number")
.WithOpenApi();

app.Run();

static long FindNthPrime(int n)
{
    int count = 0;
    long candidate = 2;

    while (count < n)
    {
        long divisor = 2;
        int isPrime = 1;

        while (divisor * divisor <= candidate)
        {
            if (candidate % divisor == 0)
            {
                isPrime = 0;
                break;
            }
            divisor++;
        }

        if (isPrime > 0)
        {
            count++;
        }

        candidate++;
    }

    return candidate - 1; // Return the found prime number
}