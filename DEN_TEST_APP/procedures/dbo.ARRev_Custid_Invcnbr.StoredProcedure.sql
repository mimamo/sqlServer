USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_Custid_Invcnbr]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_Custid_Invcnbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[ARRev_Custid_Invcnbr] @parm1 varchar(15), @parm2 varchar(10) as
SELECT *
  FROM ARAdjust
 WHERE CustID = @parm1
   AND adjdrefnbr = @parm2
   AND AdjdDoctype IN ('IN','DM','FI','NC')
ORDER BY AdjdDoctype
GO
