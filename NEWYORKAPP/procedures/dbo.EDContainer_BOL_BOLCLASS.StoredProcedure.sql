USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_BOL_BOLCLASS]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_BOL_BOLCLASS] @parm1 varchar(20) As
Select * from EDContainer A, EDContainerDet B, inventoryadg C,  EDBOLCLASS D
where A.BOLNbr = @parm1 and A.ContainerId = B.ContainerId  and b.invtid = c.invtid
and c.BOLClass = D.BOLClass order by A.ContainerId, c.BOLClass
GO
