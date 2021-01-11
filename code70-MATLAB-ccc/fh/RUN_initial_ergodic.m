clear
%% PROGRAM NAME: Plot of initial vs. ergodic distribution

%% 1. LOAD THE DATA
	load('DAT.mat')

%% 2. DEFINE INPUTS
	%%% 2.1 Variables for the analysis
		XYdata=[x y]; Xdataname='Relative Functional Health in 1990'; Ydataname='Relative Functional Health in 2016';

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

	%% 4.1   plot of initial vs. ergodic distribution
		fig = figure;
		ergodic=plot(z,d_marginalN,'k --','LineWidth',2);
		hold on;
		plot(z,d_ergodic,'k ','LineWidth',2);
		hold off;
		legend('Initial','Ergodic');

	%% 4.2 Save it in plotly
	fig = figure;
	ergodic=plot(z,d_marginalN,'k --','LineWidth',2);
	hold on;
	plot(z,d_ergodic,'k ','LineWidth',2);
	hold off;

	% response = fig2plotly(gcf, 'offline', true); % to save it offline
	%response = fig2plotly();
	%plotly_url = response.url;
