USE [DENVERAPP]
GO
/****** Object:  View [dbo].[frl_acctsub_view]    Script Date: 12/21/2015 15:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[frl_acctsub_view]
  (cpnyid, acct, sub, active, descr)
AS
  SELECT cpnyid, acct, sub, active, descr
    FROM vs_AcctSub (nolock)
GO
