USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_AllDMG]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDConvMeth_All    Script Date: 5/28/99 1:17:40 PM ******/
CREATE Proc [dbo].[EDConvMeth_AllDMG] @Parm1 varchar(3), @Parm2 varchar(3) As select * From EDConvMeth
Where Trans = @Parm1 And ConvCode Like @Parm2 Order By Trans, ConvCode
GO
