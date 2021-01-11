clear
%% PROGRAM NAME: Plot bivariate distribution (contour plot)
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
	M = transpose(P);
	rM=(M/(sum(sum(M))*ssize*ssize));  % re-scale M (so that volume of M equals 1)

	%% 4.1   YX contour plot with scatter plot
	%fig = figure;
    %pvl=pvlevs(rP,levels);
    %skplot=contour(z,z,rP,pvl);
	xlabel(Ydataname); ylabel(Xdataname);

	%hold on;
    %a1 = min(z):.05:max(z);
	%a2 = a1;
	%plot(a1,a2,'--k','LineWidth',2);
	%hold off;

	%% 4.2   XY contour plot with scatter plot
	fig = figure;
	mvl=pvlevs(rM,levels);
	skplot=contour(z,z,rM,mvl);
	xlabel(Xdataname); ylabel(Ydataname);

	hold on;
	a1 = min(z):.05:max(z);
	a2 = a1;
	plot(a1,a2,'--k','LineWidth',2);

	hold off;

	%% 4.2 Save it in plotly
		%response = fig2plotly(gcf, 'offline', true); % to save it offline
		%response = fig2plotly();
		%plotly_url = response.url;
