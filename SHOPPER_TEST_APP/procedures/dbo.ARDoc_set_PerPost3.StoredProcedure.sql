USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_set_PerPost3]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[ARDoc_set_PerPost3] @parm1 varchar (10), @parm2 varchar (6), @parm3 varchar (10), @parm4 varchar(15)
AS
UPDATE ARDOC SET ARDoc.PerPost = @parm2
WHERE ARDoc.BatNbr = @parm1 and ARDoc.PerPost <> @parm2 and (ARDoc.Refnbr <> @parm3 or ARDoc.CustID <> @parm4)
GO
