USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQUserAcct_DBNAV]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 9/4/2003 6:21:40 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 7/5/2002 2:44:46 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 1/7/2002 12:23:16 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 1/2/01 9:39:41 AM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 11/17/00 11:54:34 AM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 10/25/00 8:32:20 AM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 10/10/00 4:15:42 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 10/2/00 4:58:18 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 9/1/00 9:39:25 AM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 03/31/2000 12:21:23 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 2/2/00 12:18:21 PM ******/

/****** Object:  Stored Procedure dbo.RQUserAcct_DBNAV    Script Date: 12/17/97 10:48:55 AM ******/
CREATE PROCEDURE [dbo].[RQUserAcct_DBNAV] @parm1 Varchar(47), @Parm2 Varchar(10) AS
SELECT * FROM RQUserAcct where
UserID = @parm1 and
Acct Like @Parm2
ORDER BY UserID, Acct
GO
