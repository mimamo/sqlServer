USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQReqHist_ReqCntr_UniqueID_Pol_dbnav]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RQReqHist_ReqCntr_UniqueID_Pol_dbnav] @parm1 Varchar(10), @parm2 Varchar(2), @parm3 Varchar(17), @Parm4 Varchar(47)
 AS
SELECT * FROM RQReqHist
WHERE ReqNbr = @parm1 and
Reqcntr = @parm2 and
(UniqueID Like @parm3 or UniqueID = '0000')  and
UserID LIKE @Parm4 and
ApprPath = 'P'
ORDER BY ReqNbr, UniqueID, TranDate DESC, TranTime DESC, UserID, ApprPath
GO
