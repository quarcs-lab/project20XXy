clear
%% PROGRAM NAME: Plot initial vs final  vs ergodic distribution

%% 1. LOAD THE DATA
	load('DAT.mat')

%% 2. DEFINE INPUTS
	%%% 2.1 Variables for the analysis
		XYdata=[x y]; Xdataname='Log of Relative GDP per capita in 1992'; Ydataname='Log of Relative GDP per capita in 2013';

	%%% 2.2 Other Inputs (Parameters)
		bw = 'h2_dpi';              % Bandwidth
		int=36;                     % Number of non-overlapping intervals
		k='gauss';                  % Kernel
		alpha = 0.5;                % Sensitivity parameter for adaptive kernel (0 for fixed bandwidths)
		iterations=0;               % Number of iterations for trasitional dynamics (0 for half-life)
		levels = [90 75 50 25 10];  % Percentage contour levels
		savefigures = 0;            % Save figures (0 = NO; 1 = YES)

%% 3. ANALYSIS
	[z,P,d_joint,d_marginalN,d_iter,half_life,iterg,d_ergodic]=ske(XYdata,bw,int,k,iterations,alpha);
	half_life       % displays the half-life of the chain

%% 4. GRAPHIC OUTPUT
	ssize=z(2)-z(1);
	rP=(P/(sum(sum(P))*ssize*ssize));  % re-scale P (so that volume of P equals 1)

	%% 4.1   Plot initial vs final  vs ergodic distribution
		fig = figure;
		d_finalN=d_marginalN*P;
		observed=plot(z,d_marginalN,'k :','LineWidth',2);
		hold on;
		plot(z,d_finalN,'k--','LineWidth',2);
		plot(z,d_ergodic,'k ','LineWidth',2);
		hold off;
		legend('Year 1992','Year 2013', 'Ergodic');

	%% 4.2 Save it in plotly
		% Becuase plotly has issues with the legend, redraw it without legend.
		fig = figure;
		d_finalN=d_marginalN*P;
		observed=plot(z,d_marginalN,'k :','LineWidth',2);
		hold on;
		plot(z,d_finalN,'k','LineWidth',2);
		plot(z,d_ergodic,'k --','LineWidth',2);
		hold off;
		% response = fig2plotly(gcf, 'offline', true); % to save it offline
		%response = fig2plotly();
		%plotly_url = response.url;
