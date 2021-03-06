USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQPurOrdDet_all]    Script Date: 12/21/2015 16:01:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQPurOrdDet_all    Script Date: 9/4/2003 6:21:39 PM ******/

/****** Object:  Stored Procedure dbo.RQPurOrdDet_all    Script Date: 7/5/2002 2:44:43 PM ******/

/****** Object:  Stored Procedure dbo.RQPurOrdDet_all    Script Date: 1/7/2002 12:23:14 PM ******/

/****** Object:  Stored Procedure dbo.RQPurOrdDet_all    Script Date: 1/2/01 9:39:39 AM ******/

/****** Object:  Stored Procedure dbo.RQPurOrdDet_all    Script Date: 11/17/00 11:54:33 AM ******/
CREATE PROCEDURE [dbo].[RQPurOrdDet_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM PurOrdDet
	WHERE PONbr = @parm1
	   AND LineRef LIKE @parm2
	ORDER BY PONbr,
	   LineRef
GO
