USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_Header_All_SalesOrdNbr]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850_Header_All_SalesOrdNbr]  @parm1 varchar(15)  As Select * from Ed850Header where OrdNbr = @Parm1
GO
