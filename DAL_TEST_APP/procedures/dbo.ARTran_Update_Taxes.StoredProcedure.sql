USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_Update_Taxes]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[ARTran_Update_Taxes] @parm1 varchar (15), @parm2 varchar (2), @parm3 varchar(10)
AS
SELECT *  FROM artran
 WHERE custid  = @parm1 and trantype = @parm2 and refnbr = @parm3
GO
