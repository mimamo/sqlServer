USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDOCNUM_SPK0]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJDOCNUM_SPK0] @parm1 varchar (10) as
Select  *
from     PJdocnum
WHERE ID = @parm1
order by id
GO
