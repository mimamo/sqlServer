USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQAlter_UP]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQAlter_UP    Script Date: 9/4/2003 6:21:18 PM ******/

/****** Object:  Stored Procedure dbo.RQAlter_UP    Script Date: 7/5/2002 2:44:37 PM ******/

/****** Object:  Stored Procedure dbo.RQAlter_UP    Script Date: 1/7/2002 12:23:07 PM ******/

/****** Object:  Stored Procedure dbo.RQAlter_UP    Script Date: 1/2/01 9:39:32 AM ******/
CREATE PROCEDURE  [dbo].[RQAlter_UP] @parm1 as varchar(10), @parm2 as varchar(1), @parm3 as integer, @parm4 as varchar(8000) as
DECLARE @ptrval binary(16)
SELECT @ptrval = TEXTPTR(zzText)
FROM RQAlter where AlterNbr = @parm1 and AlterType = @parm2
UPDATETEXT RQAlter.zzText @ptrval @parm3 NULL  @parm4
GO
