USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CountItemsite_Invtid]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[CountItemsite_Invtid]  @Invtid Varchar(30)

As

Select Count(*) from Itemsite
where Invtid = @Invtid
  And (qtyonhand <> 0
       or qtyonpo <> 0
       or QtyCustOrd <> 0)
GO
