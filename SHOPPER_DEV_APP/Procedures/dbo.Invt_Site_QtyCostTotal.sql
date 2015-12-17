USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Invt_Site_QtyCostTotal]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Invt_Site_QtyCostTotal]
    @Parm1 VarChar(30)

as
 Select Sum(QtyOnHand),Sum(TotCost)
  From ItemSite
  Where Invtid = @Parm1
GO
