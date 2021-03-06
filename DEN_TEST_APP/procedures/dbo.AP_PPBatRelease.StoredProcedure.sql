USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_PPBatRelease]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_PPBatRelease]
    @BatNbr      VARCHAR(10),
    @BaseCuryID  VARCHAR(10),
    @ProgID      VARCHAR(8),
    @UserID      VARCHAR(10),
    @UserAddress VARCHAR(21)
AS

DECLARE 
	@Rlsed0		smallint,
	@Rlsed1		smallint,
	@RlsedB		smallint,
	@Status		char(1),
	@Error		smallint,
	@BaseDecPl	int,
	@VORefNbr	varchar(10),
	@OperType	char(1),
	@ErrMsg		smallint,
    @PerPost    VarChar(6),
    @LedgerID   VarChar(10)

SELECT @LedgerID = LedgerID from GLSetup WITH (NOLOCK)

SELECT @PerPost = PerPost from Batch WITH (NOLOCK) where Batnbr = @batnbr and module = 'ap'

SELECT @BaseDecPl = DecPl FROM Currncy WITH (NOLOCK) WHERE CuryID LIKE @BaseCuryID

SELECT	@Rlsed0 = 0, @Rlsed1 = 0, @VORefNbr = ''

CREATE TABLE #ErrorLog (
	ErrMsg	smallint,
	Param1	varchar(30),
	Param2	varchar(30))

WHILE (1=1)

  BEGIN

	/* get details one by one */
	SET ROWCOUNT 1

	SELECT	@VORefNbr = VORefNbr, @OperType = OperType
	FROM	AP_PPApplicDet
	WHERE	BatNbr = @BatNbr
	AND	VORefNbr > @VORefNbr
	
	IF @@ROWCOUNT = 0 BREAK

	SET ROWCOUNT 0

	IF @OperType = 'A'

		EXEC @ErrMsg = AP_ApplyPP @BatNbr, @VORefNbr, @BaseCuryID, @UserID, @UserAddress
	ELSE

		EXEC @ErrMsg = AP_UnApplyPP @BatNbr, @VORefNbr, @BaseCuryID, @UserID, @UserAddress

	INSERT #ErrorLog VALUES (@ErrMsg, @BatNbr, @VORefNbr)

  END

SET ROWCOUNT 0

/* here we set up @RlsedB and @Status */

IF EXISTS( 
	SELECT	* 
	FROM	AP_PPApplicDet
	WHERE	BatNbr = @BatNbr
	AND	Rlsed = 0)
   SELECT @Rlsed0 = 1

IF EXISTS( 
	SELECT	* 
	FROM	AP_PPApplicDet
	WHERE	BatNbr = @BatNbr
	AND	Rlsed = 1)
   SELECT @Rlsed1 = 1

IF @Rlsed0 = 0 AND @Rlsed1 = 1		/* all details were released */

   SELECT @RlsedB = 1, @Status = 'U'

ELSE IF @Rlsed0 = 1 AND @Rlsed1 = 0	/* no details were released */

   SELECT @RlsedB = 0, @Status = 'S'

ELSE 					/* partially released */

   SELECT @RlsedB = 0, @Status = 'S'

UPDATE AP_PPApplicBat
SET	LUpd_DateTime = getdate(), 
	LUpd_Prog = @ProgID, 
	LUpd_User = @UserID 
WHERE	BatNbr = @BatNbr

UPDATE	Batch
SET	CrTot = ts.CrTranSum,
	CtrlTot = Round((ts.CrTranSum + ts.DrTranSum) / 2, @BaseDecPl),
	CuryCrTot = ts.CuryCrSum,
	CuryCtrlTot = Round((ts.CuryCrSum + ts.CuryDrSum)  / 2, @BaseDecPl),
	CuryDrTot = ts.CuryDrSum,
	CuryId = ts.CuryId,
	CuryMultDiv = ts.CuryMultDiv, 
	CuryRate = ts.CuryRate,
	DrTot = ts.DrTranSum,
	LUpd_DateTime = GETDATE(), 
	LUpd_Prog = @ProgID, 
	LUpd_User = @UserID,
	Rlsed = @RlsedB,
	Status = @Status,
	LedgerID = @LedgerID,
	BalanceType = (Select BalanceType from Ledger WITH (NOLOCK) where ledgerID = @LedgerID)

FROM (SELECT COALESCE(SUM(a.CrAmt),0) AS CrTranSum, COALESCE(SUM(a.DrAmt),0) AS DrTranSum,
             COALESCE(SUM(a.CuryCrAmt),0) AS CuryCrSum, COALESCE(SUM(a.CuryDrAmt),0) AS CuryDrSum,
      MAX(CuryId) AS CuryId, MAX(CuryMultDiv) AS CuryMultDiv, MAX(CuryRate) AS CuryRate
      FROM GLTran a
      WHERE a.BatNbr = @BatNbr and a.Module = 'AP') ts
WHERE	BatNbr = @BatNbr
AND	Module = 'AP'

IF @@ERROR <> 0 
  /* an error has occurred while %s */
  INSERT #ErrorLog VALUES (3526, 'update table Batch','')

FINISH:
	SELECT * FROM #ErrorLog
GO
