USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POUserSubAcct_DBNAV]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POUserSubAcct_DBNAV    Script Date: 12/17/97 10:48:55 AM ******/
CREATE PROCEDURE [dbo].[POUserSubAcct_DBNAV] @parm1 Varchar(47), @Parm2 Varchar(24) AS
SELECT * FROM POUserSubacct where
UserID = @parm1 and
Sub Like @Parm2
ORDER BY UserID, Sub
GO
