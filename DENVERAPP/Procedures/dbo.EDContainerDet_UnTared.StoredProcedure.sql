USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_UnTared]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_UnTared] @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.*,B.LineRef From EDContainer A Inner Join EDContainerDet B On A.ContainerId = B.ContainerId
 Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.TareFlag = 0 And LTrim(A.TareId) = ''
GO
