USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Invt_Site_QtyCostTotal]    Script Date: 12/21/2015 16:07:08 ******/
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
