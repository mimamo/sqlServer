USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Batch_CustID_Rlsed2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_Batch_CustID_Rlsed2] @parm1 varchar ( 15), @parm2 varchar(47), @parm3 varchar(7), @parm4 varchar(1), @parm5 varchar (6)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
SELECT * FROM ARDoc, Currncy, Batch
 WHERE ARDoc.CuryId = Currncy.CuryId AND
       batch.batnbr = ardoc.batnbr AND
       (batch.module = 'AR' OR (ARDoc.Crtd_prog = 'BIREG' AND Batch.Module = 'BI')) AND
       ARDoc.CustId = @parm1 AND
       (ARDoc.curyDocBal <> 0 OR ARDoc.CurrentNbr = 1 OR ARDoc.PerPost = @parm5) AND
       ARDoc.Rlsed = 1 AND
       ARDoc.Cpnyid IN

             (SELECT Cpnyid
                FROM vs_share_usercpny
               WHERE userid = @parm2
                 AND scrn = @parm3
                 AND seclevel >= @parm4)

 ORDER BY CustId DESC, DocDate DESC
GO
