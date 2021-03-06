USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitabilityDrillDown]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitabilityDrillDown]
	 @CompanyKey int	 
	,@ProjectKey int
	,@ClientKey int
	,@GLCompanyKey int
	,@OfficeKey int
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	,@Mode smallint
	,@DataField varchar(100)
	,@DetailKey int = NULL --Used by the Client & Project P&L Detail to pass in either a GLAccountKey, ItemKey, or ServiceKey
	,@NullProjectType int = 0 
	,@UserKey int = null

AS --Encrypt

/*
|| When      Who Rel      What
|| 11/13/07  CRG 8.5      Added DetailKey in order to limit the data to a certain GLAccountKey, ItemKey, or ServiceKey.
|| 11/26/07  CRG 8.5      Modified for new column calculations.
|| 03/31/08  CRG 8.5.0.7  (23530) Removed commented out code so that Drilldown matches the Mutli report from bug #20497.
|| 09/16/08  GHL 10.009   (32478) Time entry regardless of GL transactions must be in
|| 10/27/08  CRG 10.0.1.1 (33250) Modified for the new Project P&L Detail
|| 01/16/08  GHL 10.0.1.7 (42944) Added Source Company Name. 
||                        Since the source company can be client or vendor, it cannot be formatted with an ID
|| 2/25/10   GWG 10.5.1.9 (75453) Added a filter in revenue for Client and changed the project filter to isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
|| 3/5/10    RLB 10.5.1.9 If a ClientKey is null and a ProjectKey is passed in set the ClientKey to that project
|| 11/7/11   GHL 10.5.5.0 (125612) Added NullProjectType parameter because users want to see the null drilldown recs
||                         when detail key is negative (means = project type) if DetailKey <0 and NullProjectType = 1
||                         query recs where isnull(pt.ProjectTypeKey, 0) = 0. 
||                         Also added same logic to InsideCostsDirect section
|| 04/10/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 04/08/13  GHL 10.567   (174141) Modified the query as (ClientKey is null or t.ClientKey=ClientKey) for revenue
||                         this seems better for parent companies because invoices are created for child clients
|| 09/11/13  GHL 10.572   (189793) For InsideExpenseCosts, removed joins with posted transactions for consistency
||                         with spRptProfitByClientMulti
|| 09/27/13 GHL 10.572  (188701) In the NO CLIENT row, remove the overhead transactions
|| 01/02/14 GHL 10.575  Reading now vHTransaction for home currency + convert mc and er net to home currency
|| 02/20/15 GAR	10.589  (246863) In OutsideCostsDirect, we were not showing all transactions when we drilled into an account.
||						Change was made to ignore client key when a project key is used.
|| 03/17/15 WDF 10.590  (249338) Added Rounding to 'Labor' calculations
*/

declare @Revenue decimal(24,4)
declare @TotalOverhead decimal(24,4)
declare @TotalAGI decimal (24,4)
declare @TotalHours decimal (24,4)
declare @TotalLaborCost decimal (24,4)
declare @TotalBillings decimal (24,4)
declare	@AccountType int

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

if @OfficeKey = 0
	select @OfficeKey = null

-- for revenue, do not pull the client, because of invoices for child companies
Declare @PullClient int 
Select @PullClient = 1
if @Mode = 1 And @DataField = 'Revenue'
	Select @PullClient = 0

if @ClientKey is null and @ProjectKey is not null and @PullClient = 1
		select @ClientKey = ClientKey from tProject (nolock) where ProjectKey = @ProjectKey


	if @Mode = 1 -- Project Profitability - Multi
		begin
			if @DataField = 'Revenue' or @DataField = 'OtherIncomeDirect'
				begin
					if @DataField = 'Revenue'
						select @AccountType = 40
					else
						select @AccountType = 41

					-- separate query for revenue booked to overhead clients or no client
					if @ClientKey = -1
						BEGIN
							select
								t.Entity
								,t.EntityKey
								,t.TransactionDate
								,t.Reference
								,sum(t.Debit) as Debit
								,sum(t.Credit) as Credit
								,c.CustomerID + '-' + c.CompanyName as FormattedClientName
								,sc.CompanyName as SourceCompanyName
								,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
								,glc.GLCompanyName
								,o.OfficeName
							from vHTransaction t (nolock) 
							inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
							left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
							left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
							left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
							left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
							left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
							where t.CompanyKey = @CompanyKey
							and (t.ProjectKey = @ProjectKey or @ProjectKey is null)
							--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
							
							AND (	-- case when @GLCompanyKey = ALL
									(@GLCompanyKey IS NULL AND 
										(
										@RestrictToGLCompany = 0 OR 
										(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
										)
									)
									--case when @GLCompanyKey = X or Blank(0)
									OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							    )

							and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
							and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
							and gl.AccountType = @AccountType 
							--and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null) --188701
							and t.ClientKey is null -- 188701
							group by t.Entity
									,t.EntityKey
									,t.TransactionDate
									,t.Reference
									,c.CustomerID + '-' + c.CompanyName
									,sc.CompanyName
									,p.ProjectNumber + '-' + p.ProjectName
									,glc.GLCompanyName
									,o.OfficeName
							order by Entity, TransactionDate
						END
						ELSE
						BEGIN
							IF ISNULL(@DetailKey, 0) >= 0
							BEGIN
								select
									t.Entity
									,t.EntityKey
									,t.TransactionDate
									,t.Reference
									,sum(t.Debit) as Debit
									,sum(t.Credit) as Credit
									,c.CustomerID + '-' + c.CompanyName as FormattedClientName
									,sc.CompanyName as SourceCompanyName
									,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
									,glc.GLCompanyName
									,o.OfficeName
								from vHTransaction t (nolock) 
								inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
								left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
								left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
								left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
								left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
								left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
								where t.CompanyKey = @CompanyKey
								and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
								and (@ClientKey is null or isnull(t.ClientKey, 0) = isnull(@ClientKey, 0))
								--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
								
								AND (	-- case when @GLCompanyKey = ALL
									(@GLCompanyKey IS NULL AND 
										(
										@RestrictToGLCompany = 0 OR 
										(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
										)
									)
									--case when @GLCompanyKey = X or Blank(0)
									OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							    )

								and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
								and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
								and gl.AccountType = @AccountType
								and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)
								and isnull(t.Overhead, 0) = 0	
								group by t.Entity
										,t.EntityKey
										,t.TransactionDate
										,t.Reference
										,c.CustomerID + '-' + c.CompanyName
										,sc.CompanyName
										,p.ProjectNumber + '-' + p.ProjectName
										,glc.GLCompanyName
										,o.OfficeName
								order by Entity, TransactionDate							
							END
							ELSE
							BEGIN
								select
									t.Entity
									,t.EntityKey
									,t.TransactionDate
									,t.Reference
									,sum(t.Debit) as Debit
									,sum(t.Credit) as Credit
									,c.CustomerID + '-' + c.CompanyName as FormattedClientName
									,sc.CompanyName as SourceCompanyName
									,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
									,glc.GLCompanyName
									,o.OfficeName
								from vHTransaction t (nolock) 
								inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
								left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
								left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
								left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
								left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
								left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
								where t.CompanyKey = @CompanyKey
								and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
								and isnull(t.ClientKey, 0) = isnull(@ClientKey, 0)
								--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
								
								AND (	-- case when @GLCompanyKey = ALL
									(@GLCompanyKey IS NULL AND 
										(
										@RestrictToGLCompany = 0 OR 
										(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
										)
									)
									--case when @GLCompanyKey = X or Blank(0)
									OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							    )
															
								and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
								and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
								and gl.AccountType = @AccountType
								and isnull(t.Overhead, 0) = 0	
								group by t.Entity
										,t.EntityKey
										,t.TransactionDate
										,t.Reference
										,c.CustomerID + '-' + c.CompanyName
										,sc.CompanyName
										,p.ProjectNumber + '-' + p.ProjectName
										,glc.GLCompanyName
										,o.OfficeName
								order by Entity, TransactionDate
							END
						END

				end

			if @DataField = 'OutsideCostsDirect'
				begin
					IF ISNULL(@DetailKey, 0) >= 0
					BEGIN
						select
							t.Entity
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,sum(t.Debit) as Debit
							,sum(t.Credit) as Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
							,sc.CompanyName as SourceCompanyName
							,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						where t.CompanyKey = @CompanyKey
						
						--(246863) In OutsideCostsDirect, we were not showing all transactions when we drilled into an account.
						-- Change was made to ignore client key when a project key is used.  I commented out these first 2 lines and added the third.
						--and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
						--and isnull(t.ClientKey, 0) = isnull(@ClientKey, 0)
						AND ((isnull(@ProjectKey, 0) > 0 AND t.ProjectKey = @ProjectKey) OR (isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0) AND isnull(t.ClientKey, 0) = isnull(@ClientKey,0)))
	
						--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
								--case when @GLCompanyKey = X or Blank(0)
								OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							)
													
						and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = 50
						and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)
						and isnull(t.Overhead, 0) = 0	
						group by t.Entity
								,t.EntityKey
								,t.TransactionDate
								,t.Reference
								,c.CustomerID + '-' + c.CompanyName
								,sc.CompanyName
								,p.ProjectNumber + '-' + p.ProjectName
								,glc.GLCompanyName
								,o.OfficeName
						order by Entity, TransactionDate
					END
					ELSE
					BEGIN
						select
							t.Entity
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,sum(t.Debit) as Debit
							,sum(t.Credit) as Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
							,sc.CompanyName as SourceCompanyName
							,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						where t.CompanyKey = @CompanyKey
						and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
						and isnull(t.ClientKey, 0) = isnull(@ClientKey, 0)
						--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)
													
						and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = 50
						and isnull(t.Overhead, 0) = 0	
						group by t.Entity
								,t.EntityKey
								,t.TransactionDate
								,t.Reference
								,c.CustomerID + '-' + c.CompanyName
								,sc.CompanyName
								,p.ProjectNumber + '-' + p.ProjectName
								,glc.GLCompanyName
								,o.OfficeName
						order by Entity, TransactionDate
					END
				end
				
			if @DataField = 'LaborHours' or @DataField = 'InsideLaborCost'
				begin
					select
						 t.WorkDate
						,isnull(t.ActualHours, 0) as ActualHours
						,round(isnull(t.ActualHours, 0) * isnull(t.HCostRate, 0), 2) as NetAmount
						,case
							when t.BilledHours is null then isnull(t.ActualHours, 0) * isnull(t.ActualRate, 0)
							else isnull(t.BilledHours, 0) * isnull(t.BilledRate, 0)
						 end as GrossAmount
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,s.ServiceCode + '-' + s.Description as FormattedServiceName
						,d.DepartmentName
					from tTime t (nolock) 
					inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
					left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
					left outer join tTask tk (nolock) on t.TaskKey = tk.TaskKey
					left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
					left outer join tDepartment d (nolock) on s.DepartmentKey = d.DepartmentKey	
					where ts.CompanyKey = @CompanyKey
					and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
					and (isnull(p.ClientKey, 0) = isnull(@ClientKey, 0) OR @DetailKey is not null) --If DetailKey is passed in, don't restrict on Client
					--and (isnull(p.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)
												
					and (isnull(p.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
					and ts.CompanyKey = @CompanyKey
					and t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
					and ts.Status = 4
					AND	ISNULL(c.Overhead, 0) = 0
					and (s.ServiceKey = @DetailKey OR @DetailKey is null)
					order by d.DepartmentName, s.ServiceCode, t.WorkDate
				end												

			if @DataField = 'InsideCostsDirect' or @DataField = 'OtherCostsDirect'
				begin
					if @DataField = 'InsideCostsDirect'
						select @AccountType = 51
					else
						select @AccountType = 52

					select
						t.Entity
						,t.EntityKey
						,t.TransactionDate
						,t.Reference
						,sum(t.Debit) as Debit
						,sum(t.Credit) as Credit
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,sc.CompanyName as SourceCompanyName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,glc.GLCompanyName
						,o.OfficeName
					from vHTransaction t (nolock) 
					inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
					left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
					left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
					left outer join tCompany c (nolock) on t.ClientKey = c.CompanyKey
					left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
					left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
					where t.CompanyKey = @CompanyKey
					and isnull(t.ProjectKey, 0) = isnull(@ProjectKey, 0)
					and (isnull(t.ClientKey, 0) = isnull(@ClientKey, 0) OR @DetailKey is not null) --If DetailKey is passed in, don't restrict on Client
					--and (isnull(t.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					)				
					
					and (isnull(t.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
					and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
					and gl.AccountType = @AccountType
					and isnull(t.Overhead, 0) = 0
					and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)	
					group by t.Entity
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,c.CustomerID + '-' + c.CompanyName
							,sc.CompanyName
							,p.ProjectNumber + '-' + p.ProjectName
							,glc.GLCompanyName
							,o.OfficeName
					order by Entity, TransactionDate
				end				

			if @DataField = 'InsideExpenseCost'
				begin
					select
						 'Misc Cost' as Entity
						,m.ExpenseDate
						,isnull(m.Quantity, 0) as Quantity
						,round(isnull(m.TotalCost, 0) * m.ExchangeRate,2) as Net
						,case
							when m.AmountBilled is null then isnull(m.BillableCost, 0)
							else m.AmountBilled
						 end as Gross
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,i.ItemID + '-' + i.ItemName as FormattedItemServiceName
						,d.DepartmentName
					from tMiscCost m (nolock) 
					inner join tProject p (nolock) on m.ProjectKey = p.ProjectKey
					left outer join tTask tk (nolock) on m.TaskKey = tk.TaskKey
					left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
					left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey					
					where m.ProjectKey = @ProjectKey
					and (isnull(p.ClientKey, 0) = isnull(@ClientKey, 0) OR @DetailKey is not null) --If DetailKey is passed in, don't restrict on Client
					and (isnull(p.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
					--and (isnull(p.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)
												
					and m.ExpenseDate >= @StartDate and m.ExpenseDate <= @EndDate
					and (i.ItemKey = @DetailKey OR @DetailKey is null)
					--order by d.DepartmentName, i.ItemID, m.ExpenseDate
					
					union all

					select
						'Expense Rcpt' as Entity
						,m.ExpenseDate
						,isnull(m.ActualQty, 0) as Quantity
						,round(isnull(m.ActualCost, 0) * ee.ExchangeRate,2) as Net
						,case
							when m.AmountBilled is null then isnull(m.BillableCost, 0)
							else m.AmountBilled
						 end as Gross
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,i.ItemID + '-' + i.ItemName as FormattedItemServiceName
						,d.DepartmentName
					from tExpenseReceipt m (nolock) 
					inner join tExpenseEnvelope ee (nolock) on m.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
					left join tProject p (nolock) on m.ProjectKey = p.ProjectKey
					left outer join tTask tk (nolock) on m.TaskKey = tk.TaskKey
					left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
					left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey					
					where ee.CompanyKey = @CompanyKey
					and isnull(m.ProjectKey, 0) = isnull(@ProjectKey, 0)
					and (isnull(p.ClientKey, 0) = isnull(@ClientKey, 0) OR @DetailKey is not null) --If DetailKey is passed in, don't restrict on Client
					and (isnull(p.OfficeKey, 0) = isnull(@OfficeKey, 0) or @OfficeKey is null)
					--and (isnull(p.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)
												
					and m.ExpenseDate >= @StartDate and m.ExpenseDate <= @EndDate
					and ee.Status = 4
					and m.VoucherDetailKey is null --not converted to an invoice yet
					and (i.ItemKey = @DetailKey OR @DetailKey is null)
					--order by d.DepartmentName, i.ItemID, m.ExpenseDate								
				end	
				
				return 1
		end

	if @Mode = 2 -- Client Profitability - Multi
		begin
			if @DataField = 'Revenue' or @DataField = 'OtherIncomeDirect'
				begin
					if @DataField = 'Revenue'
						select @AccountType = 40
					else
						select @AccountType = 41
				
					if @ClientKey = -1
					BEGIN
						select
							t.Entity
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,t.Debit
							,t.Credit
							,'- NONE - No Client Specified'
							,glc.GLCompanyName
							,sc.CompanyName AS SourceCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						where t.CompanyKey = @CompanyKey 
						--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)

						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)

						and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = @AccountType
						--and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null) --188701
						and t.ClientKey is null -- 188701
						order by Entity, TransactionDate
					END
					ELSE
					BEGIN
						IF ISNULL(@DetailKey, 0) >= 0
							select
								t.Entity
								,t.EntityKey
								,t.TransactionDate
								,t.Reference
								,t.Debit
								,t.Credit
								,c.CustomerID + '-' + c.CompanyName as FormattedClientName
							    ,sc.CompanyName AS SourceCompanyName
								,glc.GLCompanyName
								,o.OfficeName
							from vHTransaction t (nolock) 
							inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
							inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
							left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
							left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
							left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
							where t.ClientKey = @ClientKey
							--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
							
							AND (	-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
								--case when @GLCompanyKey = X or Blank(0)
								OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							)
														
							and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
							and c.OwnerCompanyKey = @CompanyKey
							and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
							and gl.AccountType = @AccountType
							and isnull(t.Overhead, 0) = 0
							and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)
							order by Entity, TransactionDate
						ELSE
						BEGIN
							IF @NullProjectType = 1
								select @DetailKey = 0

							select
								t.Entity
								,t.EntityKey
								,t.TransactionDate
								,t.Reference
								,t.Debit
								,t.Credit
								,c.CustomerID + '-' + c.CompanyName as FormattedClientName
							    ,sc.CompanyName AS SourceCompanyName
								,glc.GLCompanyName
								,o.OfficeName
							from vHTransaction t (nolock) 
							inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
							inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
							left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
							left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
							left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
							left outer join tProject p (nolock) ON t.ProjectKey = p.ProjectKey
							left outer join tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey
							where t.ClientKey = @ClientKey
							--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
							
							AND (	-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
								--case when @GLCompanyKey = X or Blank(0)
								OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
							)

							and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
							and c.OwnerCompanyKey = @CompanyKey
							and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
							and gl.AccountType = 40 
							and isnull(t.Overhead, 0) = 0
							and isnull(pt.ProjectTypeKey, 0) = (@DetailKey * -1)  --If the report is grouped by ProjectType, send the ProjectType key in as negative.
							order by Entity, TransactionDate
					
						END
					END
				end
				
			if @DataField = 'OutsideCostsDirect'
				begin
					IF ISNULL(@DetailKey, 0) >= 0
						select
							t.Entity				
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,t.Debit
							,t.Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						    ,sc.CompanyName AS SourceCompanyName
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						where t.ClientKey = @ClientKey
						--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)
													
						and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
						and c.OwnerCompanyKey = @CompanyKey			
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = 50
						and isnull(t.Overhead, 0) = 0
						and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)
						order by Entity, TransactionDate
					ELSE
					BEGIN
						IF @NullProjectType = 1
							select @DetailKey = 0

						select
							t.Entity				
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,t.Debit
							,t.Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						    ,sc.CompanyName AS SourceCompanyName
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						left outer join tProject p (nolock) ON t.ProjectKey = p.ProjectKey
						left outer join tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey
						where t.ClientKey = @ClientKey
						--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)
													
						and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
						and c.OwnerCompanyKey = @CompanyKey			
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = 50
						and isnull(t.Overhead, 0) = 0
						and isnull(pt.ProjectTypeKey, 0) = (@DetailKey * -1)  --If the report is grouped by ProjectType, send the ProjectType key in as negative.
						order by Entity, TransactionDate
				
					END
				end				

			if @DataField = 'InsideCostsDirect' or @DataField = 'OtherCostsDirect'
				begin
					if @DataField = 'InsideCostsDirect'
						select @AccountType = 51
					else
						select @AccountType = 52
				
					IF ISNULL(@DetailKey, 0) >= 0
						select
							 t.Entity				
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,t.Debit
							,t.Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
							,sc.CompanyName AS SourceCompanyName 
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						where t.ClientKey = @ClientKey
						--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)

						and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
						and c.OwnerCompanyKey = @CompanyKey			
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = @AccountType
						and isnull(t.Overhead, 0) = 0
						and (gl.GLAccountKey = @DetailKey OR @DetailKey is null)
						order by Entity, TransactionDate
					ELSE
					BEGIN
						IF @NullProjectType = 1
							select @DetailKey = 0

						select
							t.Entity				
							,t.EntityKey
							,t.TransactionDate
							,t.Reference
							,t.Debit
							,t.Credit
							,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						    ,sc.CompanyName AS SourceCompanyName
							,glc.GLCompanyName
							,o.OfficeName
						from vHTransaction t (nolock) 
						inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
						inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
						left outer join tCompany sc (nolock) on t.SourceCompanyKey = sc.CompanyKey
						left outer join tGLCompany glc (nolock) on t.GLCompanyKey = glc.GLCompanyKey
						left outer join tOffice o (nolock) on t.OfficeKey = o.OfficeKey
						left outer join tProject p (nolock) ON t.ProjectKey = p.ProjectKey
						left outer join tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey
						where t.ClientKey = @ClientKey
						--and (isnull(@GLCompanyKey, 0) = isnull(t.GLCompanyKey, 0) or @GLCompanyKey is null)
						
						AND (	-- case when @GLCompanyKey = ALL
							(@GLCompanyKey IS NULL AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
							--case when @GLCompanyKey = X or Blank(0)
							OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
						)
													
						and (isnull(@OfficeKey, 0) = isnull(t.OfficeKey, 0) or @OfficeKey is null)
						and c.OwnerCompanyKey = @CompanyKey			
						and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
						and gl.AccountType = @AccountType
						and isnull(t.Overhead, 0) = 0
						and isnull(pt.ProjectTypeKey, 0) = (@DetailKey * -1)  --If the report is grouped by ProjectType, send the ProjectType key in as negative.
						order by Entity, TransactionDate
					END

				end				

				
			if @DataField = 'LaborHours' or @DataField = 'InsideLaborCost'
				begin
					select
						 t.WorkDate
						,isnull(t.ActualHours, 0) as ActualHours
						,round(isnull(t.ActualHours, 0) * isnull(t.HCostRate, 0), 2) as NetAmount
						,case
							when t.BilledHours is null then isnull(t.ActualHours, 0) * isnull(t.ActualRate, 0)
							else isnull(t.BilledHours, 0) * isnull(t.BilledRate, 0)
						 end as GrossAmount
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,s.ServiceCode + '-' + s.Description as FormattedServiceName
						,d.DepartmentName
					from tTime t (nolock)
					inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
					inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
					inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tTask tk (nolock) on t.TaskKey = tk.TaskKey
					left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
					left outer join tDepartment d (nolock) on s.DepartmentKey = d.DepartmentKey		
					/*			
					INNER JOIN 
							(SELECT DISTINCT ProjectKey
							FROM	tTransaction (nolock)
							INNER JOIN tGLAccount ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
							WHERE	tTransaction.TransactionDate >= @StartDate AND tTransaction.TransactionDate <= @EndDate
							AND		tGLAccount.AccountType IN (40, 41, 50, 51, 52)
							AND		(ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
							AND		tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
					*/
					where ts.CompanyKey = @CompanyKey
					and p.ClientKey = @ClientKey
					--and (isnull(@GLCompanyKey, 0) = isnull(p.GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)
												
					and (isnull(@OfficeKey, 0) = isnull(p.OfficeKey, 0) or @OfficeKey is null)
					and t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
					and ts.Status = 4
					and (s.ServiceKey = @DetailKey OR @DetailKey is null)
					order by d.DepartmentName, s.ServiceCode, t.WorkDate
					
				end												
		
			if @DataField = 'InsideExpenseCost'
				begin
					select
						 'Misc Cost' as Entity
						,m.ExpenseDate
						,isnull(m.Quantity, 0) as Quantity
						,round(isnull(m.TotalCost, 0) * m.ExchangeRate, 2) as Net
						,case
							when m.AmountBilled is null then isnull(m.BillableCost, 0)
							else m.AmountBilled
						 end as Gross
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,i.ItemID + '-' + i.ItemName as FormattedItemServiceName
						,d.DepartmentName
					from tMiscCost m (nolock) 
					inner join tProject p (nolock) on m.ProjectKey = p.ProjectKey
					inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tTask tk (nolock) on m.TaskKey = tk.TaskKey
					left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
					left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey
					/* Removed Restrictions on project posted because spRptProfitByClientMulti does it that way
					INNER JOIN 
							(SELECT DISTINCT ProjectKey
							FROM	tTransaction (nolock)
							INNER JOIN tGLAccount (nolock) ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
							WHERE	TransactionDate >= @StartDate and TransactionDate <= @EndDate
							AND		tGLAccount.AccountType in (40, 41, 50, 51, 52)
							--AND		(tTransaction.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
							
							AND (	-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND tTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
								--case when @GLCompanyKey = X or Blank(0)
								OR (@GLCompanyKey IS NOT NULL AND ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey)
							)

							AND		(tTransaction.OfficeKey = @OfficeKey OR @OfficeKey IS NULL)
							AND		 tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
					*/
					where p.CompanyKey = @CompanyKey
					and p.ClientKey = @ClientKey
					and m.ExpenseDate >= @StartDate and m.ExpenseDate <= @EndDate
					--and (isnull(@GLCompanyKey, 0) = isnull(p.GLCompanyKey, 0) or @GLCompanyKey is null)
								
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)
												
					and (isnull(@OfficeKey, 0) = isnull(p.OfficeKey, 0) or @OfficeKey is null)
					and (i.ItemKey = @DetailKey OR @DetailKey is null)
					
					union all

					select
						'Expense Rcpt' as Entity
						,m.ExpenseDate
						,isnull(m.ActualQty, 0) as Quantity
						,round(isnull(m.ActualCost, 0) * ee.ExchangeRate, 2) as Net
						,case
							when m.AmountBilled is null then isnull(m.BillableCost, 0)
							else m.AmountBilled
						 end as Gross
						,tk.TaskID + '-' + tk.TaskName as FormattedTaskName
						,p.ProjectNumber + '-' + p.ProjectName as FormattedProjectName
						,c.CustomerID + '-' + c.CompanyName as FormattedClientName
						,i.ItemID + '-' + i.ItemName as FormattedItemServiceName
						,d.DepartmentName
					from tExpenseReceipt m (nolock) 
					inner join tExpenseEnvelope ee (nolock) on m.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
					inner join tProject p (nolock) on m.ProjectKey = p.ProjectKey
					left outer join tTask tk (nolock) on m.TaskKey = tk.TaskKey
					left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
					left outer join tItem i (nolock) on m.ItemKey = i.ItemKey
					left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey					
					/* Removed Restrictions on project posted because spRptProfitByClientMulti does it that way
					INNER JOIN 
							(SELECT DISTINCT ProjectKey
							FROM	tTransaction (nolock)
							INNER JOIN tGLAccount (nolock) ON tTransaction.GLAccountKey = tGLAccount.GLAccountKey
							WHERE	TransactionDate >= @StartDate and TransactionDate <= @EndDate
							AND		tGLAccount.AccountType in (40, 41, 50, 51, 52)
							--AND		(tTransaction.GLCompanyKey = @GLCompanyKey OR @GLCompanyKey IS NULL)
							
							AND (	-- case when @GLCompanyKey = ALL
								(@GLCompanyKey IS NULL AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND tTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
								--case when @GLCompanyKey = X or Blank(0)
								OR (@GLCompanyKey IS NOT NULL AND ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey)
							)

							AND		(tTransaction.OfficeKey = @OfficeKey OR @OfficeKey IS NULL)
							AND		 tTransaction.CompanyKey = @CompanyKey) AS pKeys ON p.ProjectKey = pKeys.ProjectKey
					*/
					where p.CompanyKey = @CompanyKey
					and p.ClientKey = @ClientKey
					and m.ExpenseDate >= @StartDate and m.ExpenseDate <= @EndDate
					and ee.Status = 4
					and m.VoucherDetailKey is null --not converted to an invoice yet
					--and (isnull(@GLCompanyKey, 0) = isnull(p.GLCompanyKey, 0) or @GLCompanyKey is null)
					
					AND (	-- case when @GLCompanyKey = ALL
						(@GLCompanyKey IS NULL AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
						--case when @GLCompanyKey = X or Blank(0)
						OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)

					and (isnull(@OfficeKey, 0) = isnull(p.OfficeKey, 0) or @OfficeKey is null)
					and (i.ItemKey = @DetailKey OR @DetailKey is null)								
				end	
				
				return 1
		end
		
		
	return 1
GO
