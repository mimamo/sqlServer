USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_BOL_BOLCLASS]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDContainer_BOL_BOLCLASS] @parm1 varchar(20) As
Select * from EDContainer A, EDContainerDet B, inventoryadg C,  EDBOLCLASS D
where A.BOLNbr = @parm1 and A.ContainerId = B.ContainerId  and b.invtid = c.invtid
and c.BOLClass = D.BOLClass order by A.ContainerId, c.BOLClass
GO
