USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APCheck_Delete_Detail]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
---DCR rollover from 2.5 7/5/98
Create Procedure [dbo].[APCheck_Delete_Detail] @parm1 varchar ( 255) as
Select * from APDoc where DocClass = 'C' and PerClosed <= @parm1 and Perclosed <> ' '
Order by DocClass, RefNbr
GO
