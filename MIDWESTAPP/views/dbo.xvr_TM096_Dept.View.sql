USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_TM096_Dept]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--done
CREATE VIEW [dbo].[xvr_TM096_Dept]

AS

SELECT DISTINCT gl_subacct
, bill_batch_id
FROM PJTRAN
WHERE acct = 'LABOR'
GO
