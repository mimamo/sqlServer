USE [MID_DEV_APP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[xvr_PA931_ActCom]

AS


/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA931_ActCom.sql


	select * 
	from MID_DEV_APP.dbo.xvr_PA931_ActCom with (nolock)
	where project = '00517714AGY'


    select project, project_billwith, * 
	from MID_DEV_APP.dbo.PJBILL
	where project = '00515814AGY'
		or project_billwith = '00515814AGY'
     
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
with cte as
(
	select Project = t.project,
				Task = t.pjt_entity,
				Acct = coalesce(a.acct, ''),
				PONbr = coalesce(a.tr_id03, ''),
				VendorID = coalesce(a.vendor_num, ''),
				VouchNum = coalesce(a.voucher_num, ''),
				VouchLine = coalesce(a.voucher_line, ''),
				EmployeeID = coalesce(a.employee, ''),
				TranDate = coalesce(a.trans_date, '01/02/2000'),
				Amount = coalesce(CASE WHEN coalesce(d.ih_id12, '') = ''
								THEN a.amount 
								WHEN coalesce(d.ih_id12, '') <> ''
								THEN -a.amount --void invoice fix
								ELSE 0 end, 0),
				Units = coalesce(a.units, 0),
				MarkupAmount = 0,
				BilledAmount = coalesce(d.amount, 0), 
				TranType = '',
				InvoiceNbr = coalesce(a.tr_id02, ''),
				d.InvFiscalNo,				
				InvoiceDate = coalesce(a.tr_id08, '01/01/1900'),
				[Description] = coalesce(a.tr_comment, ''),
				AcctGroup = coalesce(c.acct_group_cd, 'WP'),
				ClientInvNbr = coalesce(d.invoice_num,''),
				OrigInvNbr = coalesce(d.ih_id12,''),
				Invoice_Type = coalesce(d.invoice_type,''),
				OrigTranID = coalesce(a.user2, ''),
				d.inv_format_cd,
				d.inv_attach_cd,
				TransferDate = CASE WHEN a.batch_type = 'TFR'	THEN a.crtd_datetime
									ELSE '01/01/1900' 
								end		
		from mid_dev_app.dbo.PJPENT t (nolock) 
		inner join mid_dev_app.dbo.PJPROJ p 
			on t.project = p.project
		left join mid_dev_app.dbo.PJTRAN a (nolock) 
			on t.Project = a.project 
			and t.pjt_entity = a.pjt_entity 
			and GetDate() >= a.trans_date
		left join mid_dev_app.dbo.PJACCT c (nolock) 
			on c.acct = a.acct 
		left join mid_dev_app.dbo.xvr_PA931_invsum d (nolock) 
			on d.tr_id12 = a.user2 
			and GetDate() >= d.invoice_date 
		where c.acct_group_cd in ('FE','WA','LB','PB')  
			or coalesce(a.acct,'') = '' 

		union  --select for 'WP' and related 'CM' amounts

		select Project = t.project,
			Task = t.pjt_entity,
			Acct = case when c.acct_group_cd = 'CM' then 'BILLABLE'
						else coalesce(rtrim(a.acct), '') 
					end,
			PONbr = coalesce(a.tr_id03, ''),
			VendorID = coalesce(a.vendor_num, ''),
			VouchNum = coalesce(a.voucher_num, ''),
			VouchLine = coalesce(a.voucher_line, ''),
			EmployeeID = coalesce(a.employee, ''),
			TranDate = coalesce(a.trans_date, '01/02/2000'),
			Amount = sum(CASE WHEN c.acct_group_cd = 'CM'	THEN 0
								ELSE CASE WHEN coalesce(d.ih_id12, '') = '' THEN a.amount 
										ELSE 0 
									end 
							end),
			Units = sum(a.units),
			MarkupAmount = sum(CASE WHEN c.acct_group_cd = 'CM' THEN a.amount
									ELSE 0 
								end),
			BilledAmount = sum(CASE WHEN c.acct_group_cd = 'CM' THEN 0
										ELSE CASE WHEN coalesce(d.invoice_type, '') = 'REVD' THEN 0 
												ELSE coalesce(d.amount, 0) 
											end 
									end),
			TranType = '',
			InvoiceNbr = coalesce(a.tr_id02, ''),
			d.InvFiscalNo,
			InvoiceDate = coalesce(a.tr_id08, '01/01/1900'),
			[Description] = coalesce(a.tr_comment, ''),
			AcctGroup = 'WP',
			ClientInvNbr = coalesce(d.invoice_num, ''),
			OrigInvNbr = coalesce(d.ih_id12, ''),
			Invoice_Type = coalesce(d.invoice_type, ''),
			OrigTranID = coalesce(a.user2, ''),
			d.inv_format_cd,
			d.inv_attach_cd,
			TransferDate = CASE WHEN a.batch_type = 'TFR' THEN a.crtd_datetime
									ELSE '01/01/1900' 
							end 
		from mid_dev_app.dbo.PJPENT t (nolock) 
		left join mid_dev_app.dbo.PJTRAN a (nolock) 
			on t.Project = a.project 
			and t.pjt_entity = a.pjt_entity
			and GetDate() >= a.trans_date
		left join mid_dev_app.dbo.PJACCT c (nolock) 
			on c.acct = a.acct 
		left join mid_dev_app.dbo.xvr_PA931_invsum d (nolock) 
			on d.tr_id12 = a.user2
			and GetDate() >= d.invoice_date
		where c.acct_group_cd in ('WP', 'CM')
		group by t.project, t.pjt_entity, a.acct, a.tr_id03, a.vendor_num, a.employee, a.trans_date, a.tr_id02, a.tr_id08, a.tr_comment, d.invoice_num, d.ih_id12, 
			d.invoice_type, c.acct_group_cd, a.voucher_num, a.voucher_line, a.user2, d.inv_format_cd, d.inv_attach_cd, a.batch_type, a.crtd_datetime, d.InvFiscalNo
)
SELECT distinct c.Project,
		c.Task,
		c.Acct,
		c.PONbr,
		c.VendorID,
		c.VouchNum,
		c.VouchLine,
		c.EmployeeID,
		c.TranDate,
		c.Amount,
		c.Units,
		c.MarkupAmount,
		c.BilledAmount,
		c.TranType,
		c.InvoiceNbr,
		c.InvFiscalNo,				
		c.InvoiceDate,
		c.[Description],
		c.AcctGroup,
		c.ClientInvNbr,
		c.OrigInvNbr,
		c.Invoice_Type,
		c.OrigTranID,
		c.inv_format_cd,
		c.inv_attach_cd,
		c.TransferDate,
		VendName = v.[Name], 
		CustID = p.pm_id01, 
		ProdCode = p.pm_id02, 
		p.project_desc,
		ClientName = cust.[Name], 
		Product = x.descr,			
		FunctionBucket = case when t.pjt_entity = '28501' then 'TAirfare' 
								when t.pjt_entity = '28502' then 'THotel' 
								when t.pjt_entity = '28503' then 'TMeals'
								when t.pjt_entity = '28504' then 'TCarRentalTaxi' 
								when t.pjt_entity = '28505' then 'TMileage' 
								when t.pjt_entity = '28506' then 'TOther'  
								else 'Other' 
							end
from mid_dev_app.dbo.PJPENT t (nolock) 
inner join mid_dev_app.dbo.PJPROJ p (nolock) 
	on t.project = p.project
inner join cte c
	on t.project = c.project
left join mid_dev_app.dbo.Vendor v (nolock) 
	on c.VendorID = v.vendID
left join mid_dev_app.dbo.xIGProdCode x (nolock) 
	on p.pm_id02 = x.code_ID
left join mid_dev_app.dbo.Customer cust (nolock) 
	on p.pm_id01 = cust.custID
where c.InvoiceDate <> '01/01/1900'
	and c.BilledAmount <> 0



GO


