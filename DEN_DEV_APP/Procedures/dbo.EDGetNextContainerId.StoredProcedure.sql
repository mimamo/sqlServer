USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNextContainerId]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDGetNextContainerId]  @ContainerId varchar(10) OUTPUT AS
Declare @NextNum int
Declare Setup_csr Cursor For
Select LastSerContainer from ANSetup
Open Setup_csr
Begin Tran
Fetch Next From Setup_Csr into  @ContainerId
Select @NextNum = (convert(int,@ContainerId) + 1)
Select @ContainerId = Replicate('0',10 - Len(Rtrim(LTrim(str(@NextNum))))) + ltrim(rtrim(str(@NextNum)))
Update ANSetup set LastSerContainer = @ContainerId  Where Current of Setup_csr
Commit Tran
Select @ContainerId = @ContainerId  --Return value through output parm
Close Setup_csr
Deallocate Setup_csr
Return(0)
GO
