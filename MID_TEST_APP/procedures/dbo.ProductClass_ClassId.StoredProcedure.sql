USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProductClass_ClassId]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ProductClass_ClassId    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.ProductClass_ClassId    Script Date: 4/16/98 7:41:53 PM ******/
Create Procedure [dbo].[ProductClass_ClassId] @parm1 varchar ( 6) As
        Select * from ProductClass where
                ClassId = @parm1
        Order by ClassId
GO
