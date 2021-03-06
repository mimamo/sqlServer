USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNextContainerId_No_Output]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDGetNextContainerId_No_Output] AS
set nocount on
Declare @ContainerId varchar(10)
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
Close Setup_csr
Deallocate Setup_csr
set nocount off
Select @ContainerId
GO
