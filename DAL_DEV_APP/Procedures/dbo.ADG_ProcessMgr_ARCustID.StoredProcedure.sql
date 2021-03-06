USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ARCustID]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ARCustID]
as
	select		ar.CpnyID,
			ar.CustID
	from		ARDoc ar
	join		CustomerEDI ca
	on		ca.CustID = ar.CustID
	where		ca.CreditRule = 'B'
	group by	ar.CpnyID,
			ar.CustID
GO
