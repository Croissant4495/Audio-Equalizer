function out = take_input(prompt, lower, upper)
while true
    out = input(prompt);
    if isnumeric(out) && out >= lower && out <= upper
        break;
    else
        fprintf("Invalid input. Enter a number between %d and %d: ", lower, upper);
    end
end
end
