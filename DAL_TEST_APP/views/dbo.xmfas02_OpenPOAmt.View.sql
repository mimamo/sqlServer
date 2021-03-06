USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmfas02_OpenPOAmt]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmfas02_OpenPOAmt] 
as
select
 
  s.project Job,
  s.pjt_entity FunctionCode,
  ISNULL(sum(s.com_amount),0) as OpenPOAmt

from pjptdsum s

group by
  s.project,
  s.pjt_entity
GO
