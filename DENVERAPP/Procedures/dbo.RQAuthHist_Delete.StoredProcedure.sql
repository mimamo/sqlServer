USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQAuthHist_Delete]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 9/4/2003 6:21:18 PM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 7/5/2002 2:44:37 PM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 1/7/2002 12:23:08 PM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 1/2/01 9:39:33 AM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 11/17/00 11:54:28 AM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 10/25/00 8:32:13 AM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 10/10/00 4:15:35 PM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 10/2/00 4:58:11 PM ******/

/****** Object:  Stored Procedure dbo.RQAuthHist_Delete    Script Date: 9/1/00 9:39:17 AM ******/
CREATE PROCEDURE [dbo].[RQAuthHist_Delete]
@parm1 varchar(1), @parm2 varchar(16),
@parm3 varchar(2), @parm4 varchar(2),
@parm5 varchar(1), @parm6 varchar(2),
@parm7 varchar(47), @parm8 smalldatetime
as

Delete from RQAuthHist where
Auth_Type = @parm1 and
Auth_ID = @parm2 and
DocType = @parm3 and
RequestType = @parm4 and
Budgeted = @parm5 and
Authority = @parm6 and
UserID = @parm7 and
EffBegDate = @parm8 and
EffEndDate = '01/01/1900'
GO
