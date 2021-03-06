USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWIPAnalysisUnpostedDetail]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWIPAnalysisUnpostedDetail]
	(
		@CompanyKey INT
		,@AsOfDate SMALLDATETIME
		,@GLCompanyKey INT		-- -1 All, 0 NULL, >0 valid GLCompany
		,@OfficeKey INT			-- -1 All, 0 NULL, >0 valid Office
		,@ClientKey INT			-- -1 All, 0 NULL, >0 valid Client
		,@AccountManager INT	-- -1 All, 0 NULL, >0 valid user
		,@TranType VARCHAR(20)	-- 'Labor', 'Production Expenses', 'Media Expenses', 'Other Expenses'
		,@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/27/07 GHL 8.5  Creation for new WIP analysis report    
  || 11/09/07 GHL 8.5  Removed entity = wip from where clause   
  || 04/29/10 GWG 10.522 Added restict logic for unbilled amounts to not include things transfered in at a later date.
  || 04/30/12 GHL 10.555 Added UserKey for ICT logic
  || 01/6/14  GHL 10.576 Converted amounts to Home Currency
  || 02/24/15 GHL 10.589  Take in account tProject.DoNotPostWIP
  */
  
	SET NOCOUNT ON
	
	IF @AsOfDate IS NULL
		Select @AsOfDate = '1/1/1960'
	
Declare @IOClientLink int
Declare @BCClientLink int
Declare @MultiCurrency int

Select	
	@IOClientLink = ISNULL(IOClientLink, 1),
	@BCClientLink = ISNULL(BCClientLink, 1),
	@MultiCurrency = isnull(MultiCurrency, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey


Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)



	If @TranType = 'Labor'	
	begin
		/* Initial query replaced by queries below because of GLCompanySource logic
		select t.TimeKey
					,t.TimeSheetKey
					,t.WorkDate
					,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
					,t.ActualHours
					,t.ActualRate
					,ROUND(t.ActualHours * t.ActualRate,2) As TotalGross
					,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
					,s.Description AS ServiceDescription
				from tTime t (NOLOCK) 
					inner join tTimeSheet ts (NOLOCK) on t.TimeSheetKey = ts.TimeSheetKey
					inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
					inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
					left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
				Where		ts.CompanyKey = @CompanyKey
				AND			ts.Status = 4
				AND			p.NonBillable = 0
				AND			t.WorkDate <= @AsOfDate
				AND  		t.WIPPostingInKey = 0
				AND			p.CompanyKey = @CompanyKey -- Use indexes better
				-- Has not been billed at the time 
				AND			(t.DateBilled IS NULL OR t.DateBilled > @AsOfDate)
				AND			(t.TransferInDate is NULL OR t.TransferInDate <= @AsOfDate)
				AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
				AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
				AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
				AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
				AND    t.ServiceKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tService') 		
									
				Order By t.WorkDate
			*/
		
			-- Same query as in spRptWIPAnalysisSummary
		
			create table #tTime (
			ProjectKey int null
			, RetainerKey int null
			, TimeKey uniqueidentifier
			, WIPPostingInKey int null    -- initial query index IX_tTime_24
			, WIPPostingOutKey int null   -- initial query index IX_tTime_24
			, InvoiceLineKey int null     -- initial query index IX_tTime_24
			, DateBilled smalldatetime null   -- initial query index IX_tTime_24
	
			, ServiceKey int null             -- later query index PK_tTime, then IX_tTime_9
			, ActualHours decimal(24, 4) null -- later query index PK_tTime, then IX_tTime_9
			, ActualRate money null           -- later query index PK_tTime, then IX_tTime_9
	
			, WorkDate smalldatetime null         -- later query index PK_tTime, then let SQL decides
			, TransferInDate smalldatetime null   -- later query index PK_tTime, then let SQL decides
	
			, TimeSheetStatus int null  -- index PK_tTime, then IX_tTime_13   
	
			, UserKey int null -- fields below added for ICT/GLCompanySource
			, TimeSheetKey int null
			, GLCompanyKey int null
			, OfficeKey int null
			, UpdateFlag int null
			, ExchangeRate decimal(24,7) -- added 1/6/14 for Multi Currency
			)

			-- insert the time entries that never went IN WIP
			insert #tTime (ProjectKey, RetainerKey, TimeKey, WIPPostingInKey, WIPPostingOutKey, InvoiceLineKey, DateBilled, GLCompanyKey, OfficeKey,UpdateFlag)
			select t.ProjectKey, isnull(p.RetainerKey, 0), t.TimeKey, t.WIPPostingInKey, t.WIPPostingOutKey, t.InvoiceLineKey, t.DateBilled
			-- by default, pick gl comp and office from project
			, p.GLCompanyKey, p.OfficeKey, 0
			from tTime t with (index=IX_tTime_24, nolock) 
				inner join tProject p  (nolock) on t.ProjectKey = p.ProjectKey
			where p.CompanyKey = @CompanyKey
			and   p.NonBillable = 0
			and   isnull(p.DoNotPostWIP, 0) = 0
			and   t.WIPPostingInKey = 0
			AND	 (t.DateBilled IS NULL OR t.DateBilled > @AsOfDate)    
			/* commented out because of tProject.GLCompanySource
			--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
				AND     (-- case when @GLCompanyKey = ALL
						(@GLCompanyKey = -1 AND 
							(
							@RestrictToGLCompany = 0 OR 
							(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
					)

			AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
			*/
			AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
			AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

			-- check time sheet status
			-- index PK_tTime, then IX_tTime_13
			update #tTime
			set    #tTime.TimeSheetStatus = ts.Status
			      ,#tTime.TimeSheetKey = ts.TimeSheetKey 
				  ,#tTime.UserKey = ts.UserKey
			from   tTime t with (index=PK_tTime, nolock)
				  ,tTimeSheet ts (nolock)
			where  #tTime.TimeKey = t.TimeKey
			and    t.TimeSheetKey = ts.TimeSheetKey

			delete #tTime where TimeSheetStatus <> 4
	
			-- update work date/tranfer date...there is no index for that
			update #tTime
			set    #tTime.WorkDate = t.WorkDate
				  ,#tTime.TransferInDate = t.TransferInDate
			from   tTime t with (index=PK_tTime, nolock)
			where  #tTime.TimeKey = t.TimeKey

			delete #tTime where WorkDate > @AsOfDate
			delete #tTime where TransferInDate > @AsOfDate
	
			-- pull other data needed
			-- index PK_tTime, then IX_tTime_9
			update #tTime
			set    #tTime.ActualHours = t.ActualHours
				  ,#tTime.ActualRate = t.ActualRate
				  ,#tTime.ServiceKey = t.ServiceKey
			from   tTime t with (index=PK_tTime, nolock)
			where  #tTime.TimeKey = t.TimeKey

			-- now that we have a service key, we can remove services covered by retainer
			DELETE #tTime FROM tRetainerItems ri (NOLOCK) 
			WHERE  #tTime.RetainerKey > 0
			AND    #tTime.RetainerKey = ri.RetainerKey 
			AND    ri.EntityKey = #tTime.ServiceKey 
			AND    ri.Entity = 'tService'

			-- Correct gl comp and office based on project's GLCompanySource
			update #tTime
			set    #tTime.GLCompanyKey = u.GLCompanyKey
				  ,#tTime.OfficeKey = u.OfficeKey
			from   tProject p (nolock)
				  ,tUser u (nolock)
			where  #tTime.ProjectKey = p.ProjectKey
			and    #tTime.UserKey = u.UserKey
			and    isnull(p.GLCompanySource, 0) = 1

			if @GLCompanyKey >= 0
				delete #tTime where isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
			else
			begin
				-- All requested
				if @RestrictToGLCompany = 1
					delete #tTime
					where  isnull(GLCompanyKey, 0) not in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
			end

			if @OfficeKey >= 0
				delete #tTime where isnull(OfficeKey, 0) <> isnull(@OfficeKey, 0) 
	
			if @MultiCurrency = 1
			begin
				update #tTime
				set    #tTime.ExchangeRate = tTime.ExchangeRate
				from   tTime (nolock)
				where  #tTime.TimeKey = tTime.TimeKey
			end
			else
			begin
				update #tTime
				set    #tTime.ExchangeRate = 1
			end
			

			select t.TimeKey
					,t.TimeSheetKey
					,t.WorkDate
					,isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') AS UserName
					,t.ActualHours
					,ROUND(t.ActualRate * t.ExchangeRate, 2) as ActualRate
					,ROUND(ROUND(t.ActualHours * t.ActualRate,2) * t.ExchangeRate, 2) As TotalGross
					,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
					,s.Description AS ServiceDescription
				from #tTime t (NOLOCK) 
					inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
					inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
					left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
				order by WorkDate
	end
	
		
	If @TranType = 'Production Expenses'	
		Select   vd.VoucherDetailKey
					,v.VoucherKey
					,v.InvoiceNumber
					,v.PostingDate
					,vd.Quantity
					,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
					,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
					,c.VendorID
					,vd.ShortDescription
					,po.PurchaseOrderNumber
					,it.ItemName
		FROM		tVoucherDetail vd (NOLOCK)
		INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
		LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
		LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
		left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE		v.CompanyKey = @CompanyKey
		AND			v.Status = 4
		AND         v.PostingDate <= @AsOfDate 
		AND			p.NonBillable = 0
		and   isnull(p.DoNotPostWIP, 0) = 0
		AND  		vd.WIPPostingInKey = 0
		AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
		AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
		AND			it.ItemType = 0 
		-- Has not been billed at the time 
		AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
		AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
		AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
		AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
		AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tItem') 			
					
		Order By c.VendorID, v.InvoiceNumber
	
	If @TranType = 'Media Expenses'	
		Select   vd.VoucherDetailKey
					,v.VoucherKey
					,v.InvoiceNumber
					,v.PostingDate
					,vd.Quantity
					,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
					,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
					,c.VendorID
					,vd.ShortDescription
					,po.PurchaseOrderNumber
					,it.ItemName
		FROM		tVoucherDetail vd (NOLOCK)
		INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
		LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
		LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
		left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE		v.CompanyKey = @CompanyKey
		AND			v.Status = 4
		AND         v.PostingDate <= @AsOfDate 
		AND			p.NonBillable = 0
			and   isnull(p.DoNotPostWIP, 0) = 0
		AND  		vd.WIPPostingInKey = 0
		AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
		AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
		AND		   ((@IOClientLink = 1 AND it.ItemType = 1) Or (@BCClientLink = 1 AND it.ItemType = 2)) 
		-- Has not been billed at the time 
		AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
		AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
		AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
		AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
		AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
										FROM tRetainerItems ri (NOLOCK)
										WHERE ri.RetainerKey = p.RetainerKey
										AND   ri.Entity = 'tItem') 				
		
		UNION ALL
		
		Select   vd.VoucherDetailKey
					,v.VoucherKey
					,v.InvoiceNumber
					,v.PostingDate
					,vd.Quantity
					,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
					,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
					,c.VendorID
					,vd.ShortDescription
					,po.PurchaseOrderNumber
					,it.ItemName
		FROM		tVoucherDetail vd (NOLOCK)
		INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
		LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
		LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
		left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (NOLOCK) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		WHERE		v.CompanyKey = @CompanyKey
		AND			v.Status = 4
		AND         v.PostingDate <= @AsOfDate 
		AND  		vd.WIPPostingInKey = 0
		AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
		AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
		AND		   ((@IOClientLink = 2 AND it.ItemType = 1) Or (@BCClientLink = 2 AND it.ItemType = 2)) 
		-- Has not been billed at the time 
		AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
		AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(e.GLCompanyKey, 0)) )
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND e.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(e.GLCompanyKey, 0) = @GLCompanyKey)
			)
		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(e.OfficeKey, 0)) )
		AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(e.ClientKey, 0)) )
		AND    @AccountManager = -1
																				
		Order By c.VendorID, v.InvoiceNumber
			
			
		IF @TranType = 'Other Expenses'
			Select CAST('MISC COST' AS VARCHAR(50)) AS Entity
				,mc.MiscCostKey 
				, CAST('' AS VARCHAR(50)) AS InvoiceNumber
				,mc.ExpenseDate AS EntityDate
				,mc.Quantity
				,round(mc.UnitCost * mc.ExchangeRate, 2) as UnitCost
				,round(mc.TotalCost * mc.ExchangeRate, 2) as UnitCost
				,mc.ShortDescription
				,it.ItemName
			FROM		tMiscCost mc (NOLOCK)
			INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
			WHERE		p.CompanyKey = @CompanyKey
			AND			p.NonBillable = 0
				and   isnull(p.DoNotPostWIP, 0) = 0
			AND			mc.ExpenseDate <= @AsOfDate
			AND 		mc.WIPPostingInKey = 0
			-- Has not been billed at the time 
			AND			(mc.DateBilled IS NULL OR mc.DateBilled > @AsOfDate)
			AND			(mc.TransferInDate is NULL OR mc.TransferInDate <= @AsOfDate)
			--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )

			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

			AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
			AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
			AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
			AND    mc.ItemKey NOT IN (SELECT ri.EntityKey 
											FROM tRetainerItems ri (NOLOCK)
											WHERE ri.RetainerKey = p.RetainerKey
											AND   ri.Entity = 'tItem') 				
		
			UNION
			
			Select		CAST('INVOICE' AS VARCHAR(50)) AS Entity
						,vd.VoucherDetailKey As EntityKey
						,v.InvoiceNumber
						,v.PostingDate  AS EntityDate
						,vd.Quantity
						,ROUND(vd.UnitCost * v.ExchangeRate, 2) as UnitCost
						,ROUND(vd.TotalCost * v.ExchangeRate, 2) as TotalCost
						,vd.ShortDescription
						,it.ItemName
			FROM		tVoucherDetail vd (NOLOCK)
			INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
			LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
			LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
			WHERE		v.CompanyKey = @CompanyKey
			AND			v.Status = 4
			AND         v.PostingDate <= @AsOfDate 
			AND			p.NonBillable = 0
				and   isnull(p.DoNotPostWIP, 0) = 0
			AND  		vd.WIPPostingInKey = 0
			AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
			AND		    it.ItemType = 3 
			-- Has not been billed at the time 
			AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
			AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
			--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
			
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

			AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
			AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
			AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
			AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
											FROM tRetainerItems ri (NOLOCK)
											WHERE ri.RetainerKey = p.RetainerKey
											AND   ri.Entity = 'tItem') 				
						
			ORDER BY Entity DESC, InvoiceNumber, EntityDate			
RETURN 1
GO
