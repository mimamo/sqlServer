USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDConvMeth_Description]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDConvMeth_Description] @Parm1 varchar(3), @Parm2 varchar(3), @Parm3 varchar(1) As
Select Description From EDConvMeth Where Trans = @Parm1 And ConvCode = @Parm2 And Direction = @Parm3
GO
