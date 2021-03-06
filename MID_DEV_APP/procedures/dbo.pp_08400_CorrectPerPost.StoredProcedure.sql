USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_08400_CorrectPerPost]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[pp_08400_CorrectPerPost] @useraddress varchar(21)='', @Result int OUTPUT
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

SELECT @RESULT = 0

UPDATE d
SET
  d.PerPost = b.PerPost
FROM
ARDoc d
JOIN Batch b ON b.batnbr = d.batnbr AND b.module = 'AR'
JOIN WrkRelease w ON w.BatNbr = b.BatNbr AND w.Module = b.Module
WHERE
w.useraddress = @useraddress
IF @@ERROR <>0 GOTO Abort

UPDATE t
SET
  t.PerPost = b.PerPost,
  t.FiscYr = SUBSTRING(b.PerPost,1,4)
FROM
ARTran t
JOIN Batch b ON b.batnbr = t.batnbr AND b.module = 'AR'
JOIN WrkRelease w ON w.BatNbr = b.BatNbr AND w.Module = b.Module
WHERE
w.useraddress = @useraddress
IF @@ERROR <>0 GOTO Abort

GOTO Finish

Abort:
SELECT @Result = 1

Finish:
GO
