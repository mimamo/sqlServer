USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Currncy_All]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Currncy_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[Currncy_All] @parm1 varchar ( 4) as
    Select * from Currncy where CuryId like @parm1 order by CuryId
GO
