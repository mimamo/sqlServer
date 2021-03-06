USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vs_ASRReqEDD_Invc]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vs_ASRReqEDD_Invc] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(16),
		@parm4 varchar(15), @parm5 varchar(16), @parm6 varchar(15), @parm7 varchar(16),
		@parm8 int, @parm9 int, @parm10 int, @parm11 int, @parm12 varchar(2)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
AS
	select vs_asrreqedd.*,  vs_asrdistlist.*, cast (vs_appsrvrequest.status as char(1)), 
	substring(vs_appsrvrequest.ReqTStamp, 1, 8) ,
	cast (vs_appsrvrequest.priority as char(1)),
	vs_appsrvrequest.scheduleoptions
	from vs_asrreqedd, vs_appsrvrequest,vs_asrdistlist 
	where vs_asrreqedd.id = vs_appsrvrequest.id and vs_asrreqedd.id = vs_asrdistlist.requestid
	and doctype <> 'U1' and doctype <> 'D1' and InvNbr Like @parm1 and CustID like @parm2 and ARProject like @parm3
	and OrdNbr Like @parm4 and OrdProject Like @parm5 and ShipperID Like @parm6 and ShipProject Like @parm7
	and ShipDate >= @parm8 and ShipDate <= @parm9 and StmtDate >= @parm10 and StmtDate <= @parm11 and StmtCycleID Like @parm12
	ORDER BY InvNbr, CustID, ArProject
GO
