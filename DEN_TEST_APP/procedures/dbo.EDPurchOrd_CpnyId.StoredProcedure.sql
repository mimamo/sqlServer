USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_CpnyId]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_CpnyId] @PONbr varchar(10) As
Select CpnyId From PurchOrd Where PONbr = @PONbr
GO
