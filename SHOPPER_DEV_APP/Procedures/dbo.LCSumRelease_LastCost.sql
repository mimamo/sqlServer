USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCSumRelease_LastCost]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[LCSumRelease_LastCost]
	@RcptNbr varchar(15),
	@Invtid Varchar (30),
	@SiteID Varchar(10)
as
Select Sum(tranamt)
from
	Intran WITH(NOLOCK)
where
	RcptNbr = @RcptNbr
	and Invtid = @InvtID
	and SiteID = @SiteID
	and jrnltype = 'LC'
GO
