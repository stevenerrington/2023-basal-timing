function [exponentialFit, fitted_params] = fit_exponential_decay(lag, autocorr)
    % Fit an exponential decay function to autocorrelation values.
    % Inputs:
    % lag - Lag values
    % autocorr - Autocorrelation values
    
    % Initial guess for the parameters (adjust as needed)
    initial_guess = [1, 0.1]; % [A, tau]

    % Fit an exponential decay function using lsqcurvefit
    fit_func = @(params, x) params(1) * exp(-x / params(2));
    fitted_params = lsqcurvefit(fit_func, initial_guess, lag, autocorr);

    % Generate fitted curve using the obtained parameters
    exponentialFit = fitted_params(1) * exp(-lag / fitted_params(2));

end
