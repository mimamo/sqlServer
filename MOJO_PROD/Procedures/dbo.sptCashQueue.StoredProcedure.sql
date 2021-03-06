USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashQueue]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashQueue]
	(
	@CompanyKey INT
	,@Entity VARCHAR(25)
	,@EntityKey INT
	,@PostingDate SMALLDATETIME
	,@Action SMALLINT -- 0 Post, 1 Unpost
	,@AdvanceBill int = 0
	)
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 05/06/09 GHL 10.024 Restricting the number of associated entities 
||                     after getting 100 of them for an invoice on APP3
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
*/
	SET NOCOUNT ON

	/* Assume done in calling SP
	CREATE TABLE #tCashQueue(
	Entity varchar(25) NULL,
	EntityKey int NULL,
	PostingDate smalldatetime NULL,
	QueueOrder int identity(1,1),
	PostingOrder int NULL,
	Action smallint NULL, 
	AdvanceBill int NULL
	)
	*/
			
	DECLARE @QueueOrder int	
	DECLARE @CircuitBreaker int
	DECLARE @QEntity VARCHAR(50)
	DECLARE @QEntityKey INT
	DECLARE @QPostingDate SMALLDATETIME
	DECLARE @QAction INT
	DECLARE @QAdvanceBill INT
	
	-- Enter the current entity
	INSERT #tCashQueue
	   (Entity
	   ,EntityKey
	   ,PostingDate
	   ,Action
	   ,AdvanceBill)
	VALUES (@Entity, @EntityKey, @PostingDate, @Action, @AdvanceBill) 

	EXEC sptCashQueueAppliedEntities @CompanyKey, @Entity, @EntityKey, @PostingDate, @Action, @AdvanceBill

	-- The list should grow but this is not a recursive algorithm
	/*
	SELECT @CircuitBreaker = 0, @QueueOrder = 0
	WHILE (1=1)
	BEGIN
		SELECT @QueueOrder = MIN(QueueOrder)
		FROM   #tCashQueue
		WHERE  QueueOrder > @QueueOrder
		--AND    Action = 0 -- Post
		
		IF @QueueOrder IS NULL
			BREAK
		
		SELECT @CircuitBreaker = @CircuitBreaker + 1	
		IF @CircuitBreaker > 1000
			BREAK
			
		SELECT @QEntity = Entity
		      ,@QEntityKey = EntityKey
		      ,@QPostingDate = PostingDate
		      ,@QAction = Action
		      ,@QAdvanceBill = AdvanceBill
		FROM   #tCashQueue
		WHERE  QueueOrder = @QueueOrder
		      	
		EXEC sptCashQueueAppliedEntities @CompanyKey, @QEntity, @QEntityKey, @QPostingDate, @QAction, @QAdvanceBill
			
	END
	*/
		
	--select * from #tCashQueue
 		
	-- Everything which has to be posted should be unposted first
	INSERT 	#tCashQueue
			   (Entity
			   ,EntityKey
			   ,PostingDate
			   ,Action
			   )
	SELECT		Entity
			   ,EntityKey
			   ,PostingDate
			   ,1 -- Unpost
	FROM  #tCashQueue 
	WHERE Action = 0 -- Post
		
	-- Now resort everything by PostingDate, if same date invoice before check
	DECLARE @PostingOrder INT
	DECLARE @AR_AP VARCHAR(10)

	IF @Entity IN ('INVOICE', 'RECEIPT')
		SELECT @AR_AP = 'AR'
	IF @Entity IN ('VOUCHER', 'PAYMENT', 'CREDITCARD')
		SELECT @AR_AP = 'AP'
	IF @Entity IN ('GENJRNL')
		SELECT @AR_AP = 'GENJRNL' 
		
	-- At PostingOrder = 1, always place the ACCRUAL change taking place
	-- the other entities will be the associated entities
	UPDATE #tCashQueue SET PostingOrder = 0	
	UPDATE #tCashQueue SET PostingOrder = 1 WHERE Entity = @Entity AND EntityKey = @EntityKey And Action = @Action
	
	-- place the ones to unpost before 
	UPDATE #tCashQueue SET PostingOrder = -1
	WHERE Action = 1 
	AND   PostingOrder <> 1
	
	--SELECT * FROM #tCashQueue
	 
	-- now process the ones to post 
	SELECT @QPostingDate = '1/1/1900', @PostingOrder = 2
	WHILE (1=1)
	BEGIN
		SELECT @QPostingDate = MIN(PostingDate)
		FROM   #tCashQueue 
		WHERE  PostingDate > @QPostingDate
		AND    Action = 0
		AND    PostingOrder <> 1  
		
		IF @QPostingDate IS NULL
			BREAK 
	
		IF @AR_AP = 'AR'
		BEGIN
			-- process the AB invoices first
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'INVOICE'
				AND    EntityKey > @QEntityKey
				AND    AdvanceBill = 1
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'INVOICE'
				AND    EntityKey = @QEntityKey
				AND    AdvanceBill = 1
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END
			
			-- then the invoices 
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'INVOICE'
				AND    EntityKey > @QEntityKey
				AND    AdvanceBill = 0
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'INVOICE'
				AND    EntityKey = @QEntityKey
				AND    AdvanceBill = 0
					
				SELECT @PostingOrder = @PostingOrder + 1		
			END	
			
			-- process the receipts
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'RECEIPT'
				AND    EntityKey > @QEntityKey
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'RECEIPT'
				AND    EntityKey = @QEntityKey
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END
			
		END -- AR
		
		
		IF @AR_AP = 'AP'
		BEGIN
			-- process the credit cards first
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'CREDITCARD'
				AND    EntityKey > @QEntityKey
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'CREDITCARD'
				AND    EntityKey = @QEntityKey
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END

			-- process the invoices first
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'VOUCHER'
				AND    EntityKey > @QEntityKey
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'VOUCHER'
				AND    EntityKey = @QEntityKey
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END	
			
			-- process the payments
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'PAYMENT'
				AND    EntityKey > @QEntityKey
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'PAYMENT'
				AND    EntityKey = @QEntityKey
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END
			
		END -- AP


		IF @AR_AP = 'GENJRNL'
		BEGIN
			-- process the journal entries
			SELECT @QEntityKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @QEntityKey = MIN(EntityKey)
				FROM   #tCashQueue 
				WHERE  PostingDate = @QPostingDate
				AND    Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'GENJRNL'
				AND    EntityKey > @QEntityKey
				
				IF @QEntityKey IS NULL
					BREAK
							
				UPDATE #tCashQueue
				SET    PostingOrder = @PostingOrder
				WHERE  Action = 0
				AND    PostingOrder <> 1
				AND    Entity = 'GENJRNL'
				AND    EntityKey = @QEntityKey
						
				SELECT @PostingOrder = @PostingOrder + 1		
			END
			
		END -- GENJRNL
		
	END 
	
	/*
	SELECT Entity
		   ,EntityKey
		   ,PostingDate
		   ,PostingOrder
		   ,Action
	FROM  #tCashQueue
	*/
		           	
	RETURN 1
GO
