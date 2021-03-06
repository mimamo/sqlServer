USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendItem_LastCost]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[VendItem_LastCost] @VendID varchar(15), @InvtID varchar(30), @AlternateID varchar(30), @SiteID varchar(10), @PerNbr varchar(6) = '' as

select coalesce(nullif(v.LastCost,0), nullif(s.LastPurchasePrice,0), s.LastCost, 0)
from APSetup (NOLOCK)
left join VendItem v on v.VendID = @VendID and v.InvtID = @InvtID and v.AlternateID = @AlternateID and v.SiteID = @SiteID --and v.FiscYr = left(coalesce(nullif(@PerNbr,''), CurrPerNbr), 4)
left join ItemSite s on s.InvtID = @InvtID and s.SiteID = @SiteID

order by LastRcvd desc
GO
