USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850_Header_All_SalesOrdNbr]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850_Header_All_SalesOrdNbr]  @parm1 varchar(15)  As Select * from Ed850Header where OrdNbr = @Parm1
GO
