USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDiscCode_all]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDiscCode_all]
 @parm1 varchar( 15 ), @Parm2 varchar(15), @Parm3 smallint, @Parm4 varchar(1)
AS
 SELECT *
 FROM EDDiscCode
 WHERE SpecChgCode LIKE @parm1 And CustId Like @Parm2 And DiscountType Like @Parm3 And Direction Like @Parm4
 ORDER BY SpecChgCode, CustId, DiscountType, Direction
GO
